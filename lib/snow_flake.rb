require "snow_flake/version"
# /**
#  * Twitter_Snowflake<br>
#  * SnowFlake的结构如下(每部分用-分开):<br>
#  * 0 - 0000000000 0000000000 0000000000 0000000000 0 - 00000 - 00000 - 000000000000 <br>
#  * 1位标识，由于long基本类型在Java中是带符号的，最高位是符号位，正数是0，负数是1，所以id一般是正数，最高位是0<br>
#  * 41位时间截(毫秒级)，注意，41位时间截不是存储当前时间的时间截，而是存储时间截的差值（当前时间截 - 开始时间截)
#  * 得到的值），这里的的开始时间截，一般是我们的id生成器开始使用的时间，由我们程序来指定的（如下下面程序IdWorker类的startTime属性）。41位的时间截，可以使用69年，年T = (1L << 41) / (1000L * 60 * 60 * 24 * 365) = 69<br>
# * 10位的数据机器位，可以部署在1024个节点，包括5位datacenterId和5位workerId<br>
# * 12位序列，毫秒内的计数，12位的计数顺序号支持每个节点每毫秒(同一机器，同一时间截)产生4096个ID序号<br>
# * 加起来刚好64位，为一个Long型。<br>
# * SnowFlake的优点是，整体上按照时间自增排序，并且整个分布式系统内不会产生ID碰撞(由数据中心ID和机器ID作区分)，并且效率较高，经测试，SnowFlake每秒能够产生26万ID左右。
# */
module SnowFlake
  # example
  # SnowFlake::ID.new(1,1).next_id
  class ID
    attr_accessor :twepoch, :worker_id_bits, :datacenter_id_bits, :max_worker_id, :max_datacenter_id, :sequence_bits,
                  :worker_id_shift, :datacenter_id_shift, :timestamp_left_shift, :sequence_mask, :worker_id,
                  :datacenter_id, :sequence, :last_timestamp

    # @param worker_id 工作ID (0~31)
    # @param datacenter_id 数据中心ID (0~31)
    def initialize(worker_id, datacenter_id)
      self.twepoch = 1420041600000 # start time (2015-01-01)
      self.worker_id_bits = 5 # worker id bits
      self.datacenter_id_bits = 5 # datacenter id bits
      # Supported maximum worker id, resulting in 31
      self.max_worker_id = -1 ^ (-1 << worker_id_bits)
      # Supported maximum datacenter id, resulting in 31
      self.max_datacenter_id = -1 ^ (-1 << datacenter_id_bits)
      self.sequence_bits = 12 # The number of sequences in ID
      # The machine ID moves to the left 12 bits.
      self.worker_id_shift = sequence_bits
      # The data identification ID moves to the left 17 bits (12+5)
      self.datacenter_id_shift = sequence_bits + worker_id_bits
      # The time is shifted to the left by 22 bits(5+5+12)
      self.timestamp_left_shift = sequence_bits + worker_id_bits + datacenter_id_bits
      # The mask of generating sequence is 4095 (0b111111111111=0xfff=4095)
      self.sequence_mask = -1 ^ (-1 << sequence_bits)
      self.sequence = 0 # Millisecond sequence(0~4095)
      self.last_timestamp = -1 # Last timestamp of ID generation
      if worker_id > max_worker_id || worker_id < 0
        raise "worker Id can't be greater than #{max_worker_id} or less than 0"
      end
      if datacenter_id > max_datacenter_id || datacenter_id < 0
        raise "datacenter Id can't be greater than #{max_datacenter_id} or less than 0"
      end
      self.worker_id = worker_id # worker ID(0~31)
      self.datacenter_id = datacenter_id # datacenter ID(0~31)
    end

    def next_id
      timestamp = time_gen
      if timestamp < last_timestamp
        raise "Clock moved backwards.  Refusing to generate id for #{last_timestamp - timestamp} milliseconds"
      end
      if last_timestamp == timestamp
        self.sequence = (sequence + 1) & sequence_mask
        timestamp = till_next_millis(last_timestamp) if sequence.zero?
      else
        self.sequence = 0
      end
      self.last_timestamp = timestamp
      ((timestamp - twepoch) << timestamp_left_shift) | (datacenter_id << datacenter_id_shift) | (worker_id << worker_id_shift) | sequence
    end

    def till_next_millis(last_timestamp)
      timestamp = time_gen
      timestamp = time_gen while timestamp <= last_timestamp
      timestamp
    end

    def time_gen
      (Time.now.to_f * 1000).floor
    end
  end
end
