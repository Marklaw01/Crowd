<script>google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawGID);

function drawGID() {
      var queryString = encodeURIComponent('&range=A:B');

      var query = new google.visualization.Query(
          'https://docs.google.com/spreadsheets/d/1edGL2veWe-TXvGQ0-JTqXOPh8G8lkp7q9PrOyzLevaU/gviz/tq?' + queryString);
      query.send(handleQueryResponse);
    }


function handleQueryResponse(response) {
      if (response.isError()) {
        alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
        return;
      }

    // Set chart options
      var options = {'title':'prova grafico',
                     'width':600,
                     'height':400};

      var data = response.getDataTable();
			var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
      chart.draw(data, options);
    }
</script>


