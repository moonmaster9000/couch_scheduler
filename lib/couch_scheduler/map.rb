module CouchScheduler
  class Map
    include CouchView::Map

    def map
      %{
        function(doc){
          if (#{conditions}){
            if (doc.start){
              startDate = doc.start.replace(/-/g, '/')
              var start = new Date(startDate)
            } else {
              var start = new Date()
            }

            if (doc.end){
              endDate = doc.end.replace(/-/g, '/')
              var end = new Date(endDate)
            } else {
              var end = new Date("2025/01/01")
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
