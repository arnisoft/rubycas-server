module CASServer::Model
  module Ticket
    def to_s
      ticket
    end

    def self.cleanup(max_lifetime)
      transaction do
        conditions = where("created_on < ?", Time.now - max_lifetime)
        expired_tickets_count = conditions.count

        $LOG.debug("Destroying #{expired_tickets_count} expired #{self.name.demodulize}"+
          "#{'s' if expired_tickets_count > 1}.") if expired_tickets_count > 0

        conditions.destroy_all
      end
    end
  end
end
