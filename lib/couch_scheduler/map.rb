module CouchScheduler
  class Map
    include CouchView::Map

    def map
      %{
        function(doc){
          if (#{conditions}){
            if (doc.start){
              var start = new Date(doc.start)
              start.setDate(start.getDate() + 1)
            } else {
              var start = new Date(2011, 0, 1, 0, 0, 0, 0)
            }

            if (doc.end){
              var end = new Date(doc.end)
              end.setDate(end.getDate() + 1)
            } else {
              var end = new Date(2025, 0, 1, 0, 0, 0, 0)
            }
            
            while(start < end){
              year  = start.getFullYear()
              
              month = start.getMonth() + 1
              if (month < 10)
                month = "0" + month.toString()
              
              day  = start.getDate()
              if (day < 10)
                day = "0" + day.toString()

              emit(
                year + "-" + 
                month + "-" + 
                day, 
                null
              );
              start.setDate(start.getDate() + 1)
            }
          }
        }
      }
    end
  end
end
