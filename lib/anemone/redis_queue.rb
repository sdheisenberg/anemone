require "redis"
class RedisQueue
  #
  # Creates a new queue.
  #
  def initialize(name="queue")
    @que = Redis.new(:thread_safe=>true)
    @key = name
    @waiting = []
    #@que.taint		# enable tainted comunication
    @waiting.taint
    self.taint
    @mutex = Mutex.new
    clear
  end

  #
  # Pushes +obj+ to the queue.
  #
  def push(obj)
    @mutex.synchronize{
      @que.lpush(@key,Marshal.dump(obj))
      begin
        t = @waiting.shift
        t.wakeup if t
      rescue ThreadError
        retry
      end
    }
  end

  #
  # Alias of push
  #
  alias << push

  #
  # Alias of push
  #
  alias enq push

  #
  # Retrieves data from the queue.  If the queue is empty, the calling thread is
  # suspended until data is pushed onto the queue.  If +non_block+ is true, the
  # thread isn't suspended, and an exception is raised.
  #
  def pop(non_block=false)
    @mutex.synchronize{
      while true
        if empty?
          raise ThreadError, "queue empty" if non_block
          @waiting.push Thread.current
          @mutex.sleep
        else
          return Marshal.load(@que.lpop(@key))
        end
      end
    }
  end

  #
  # Alias of pop
  #
  alias shift pop

  #
  # Alias of pop
  #
  alias deq pop

  #
  # Returns +true+ if the queue is empty.
  #
  def empty?
      @que.llen(@key) == 0
  end

  #
  # Removes all objects from the queue.
  #
  def clear
    @mutex.synchronize{
      @que.del(@key)
    }
  end

  #
  # Returns the length of the queue.
  #
  def length
    @mutex.synchronize{
      @que.llen(@key)
    }
  end

  #
  # Alias of length.
  #
  alias size length

  #
  # Returns the number of threads waiting on the queue.
  #
  def num_waiting
    @waiting.size
  end
end


