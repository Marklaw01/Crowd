/*******************************************************
    linechart | 1.0
********************************************************

    HTML line charts with canvas and Jquery.

    See sample at Github :
    https://github.com/damienvingrief/linechart

*******************************************************/


(function ($){ $.linechart = function (o){

    o = $.extend({
        // Mandatory options
        id: '',                                 // id given to the chart
        data: [                                 // datas arrays
            [
              { X: 0, Y: 54, tip: 'Tooltip HTML 1#1' },
              { X: 2, Y: 28, tip: 'Tooltip HTML 1#2' }, 
              { X: 3, Y: 22, tip: 'Tooltip HTML 1#3' }
            ]
          ],
        // Other options
        gridColor: '#555555',                   // grid color
        gridFont: 'normal 11px Arial',          // grid texts font properties
        gridFontColor: '#333333',               // grid texts font color
        gridPaddingX: 30,                       // grid horizontal space between values
        gridPaddingY: 30,                       // grid vertical space between values
        gridWidth: 1,                           // grid width
        dotsHover: function(dot){},             // dots hover function
        dotsClick: function(dot){},             // dots click function
        dotsColor: '#333333',                   // dots color
        dotsWidth: 2,                           // dots width (radius)
        linesColors: [['#CC3333'],['#3333CC']], // lines colors
        linesWidth: 2,                          // lines width
        tooltipMarginX: 15,                     // tooltip horizontal margin from cursor
        tooltipMarginY: 15                      // tooltip vertical margin from cursor
    }, o);

    // Container into the DOM
    document.write('<div class="chart" id="'+o.id+'"><canvas></canvas><div></div></div>');

    // Container init
    var wrap = $('#'+o.id).addClass('linechart');
    var wrapOffset = wrap.offset();

    // Canvas size iso container
    var graph = $('> canvas', wrap).attr('width',wrap.width()).attr('height',wrap.height());

    // Canvas init
    var c = graph[0].getContext('2d');
        c.strokeStyle = o.gridColor;
        c.fillStyle = o.gridFontColor;
        c.font = o.gridFont;
        c.textAlign = "center";
    var tooltip = $('> div', wrap);

    // Return the max values in our data list
    var maxX = 0;
    var maxY = 0;
    for (j=0;j<o.data.length;j++)
    {
        for (i=0;i<o.data[j].length; i++)
        {
            if (o.data[j][i].X > maxX) maxX = o.data[j][i].X;
            if (o.data[j][i].Y > maxY) maxY = o.data[j][i].Y;
        }
        maxY += 10 - maxY % 10;
    }

    // Return the pixel position (x or y) for a graph point
    var getPixelX = function(val){ return (((graph.width() - o.gridPaddingX) / (maxX + 1)) * val + (o.gridPaddingX * 1.5)); };
    var getPixelY = function(val){ return (graph.height() - (((graph.height() - o.gridPaddingY) / maxY) * val) - o.gridPaddingY); };

    // Draw the axises
    c.beginPath();
    c.moveTo(o.gridPaddingX, 0);
    c.lineTo(o.gridPaddingX, graph.height() - o.gridPaddingY);
    c.lineTo(graph.width(), graph.height() - o.gridPaddingY);
    c.linesWidth = o.gridWidth;
    c.stroke();

    // Draw the X value texts
    for (i=0;i<=maxX;i++)
        c.fillText(i, getPixelX(i), graph.height() - o.gridPaddingY + 20);

    // Draw the Y value texts
    c.textAlign = "right"
    c.textBaseline = "middle";
    for (i=0;i<maxY;i+= 10)
        c.fillText(i, o.gridPaddingX - 10, getPixelY(i));

    for (j=0;j<o.data.length;j++)
    {
        // Add position properties to the dots
        for (i=0;i<o.data[j].length;i++)
        jQuery.extend(o.data[j][i],{
            posX: getPixelX(o.data[j][i].X),
            posY: getPixelY(o.data[j][i].Y),
            rXr: 16
        });

        // Draw the line graph
        c.strokeStyle = ((typeof o.linesColors[j] !== 'undefined')?o.linesColors[j]:'#000000');
        c.beginPath();
        c.moveTo(o.data[j][0].posX, o.data[j][0].posY);
        for (i=1;i<o.data[j].length;i++)
            c.lineTo(o.data[j][i].posX, o.data[j][i].posY);
        c.linesWidth = o.linesWidth;
        c.stroke();

        // Draw the dots
        c.fillStyle = o.dotsColor;
        for (i=0;i<o.data[j].length;i++){
            c.beginPath();
            c.arc(o.data[j][i].posX, o.data[j][i].posY, o.dotsWidth, 0, Math.PI * 2, true);
            c.fill();
        }
    }

    // Dots hover function
    wrap.mousemove(function (e){
        var dotHover = false;
        mouseX = parseInt(e.clientX - wrapOffset.left);
        mouseY = parseInt(e.clientY - wrapOffset.top);
        for (j=0;j<o.data.length;j++)
            for (i=0;i<o.data[j].length;i++){
                if (typeof o.data[j][i].tip == 'string' && o.data[j][i].tip != '')
                {
                    var dx = mouseX - o.data[j][i].posX;
                    var dy = mouseY - o.data[j][i].posY;
                    if (dx * dx + dy * dy < o.data[j][i].rXr)
                        dotHover = o.data[j][i];
                }
            }
        if (dotHover){
            dotClick = dotHover;
            tooltip.html(dotHover.tip).css({
                'position': 'absolute',
                'left': mouseX + o.tooltipMarginX,
                'top': mouseY + o.tooltipMarginY
            }).show();
            o.dotsHover(dotHover);
        } else {
            dotClick = false;
            tooltip.hide().html('').css({
                'position': 'static',
                'positionLeft': 0,
                'positionTop': 0
            });
        }
    });

    // Dots click function
    var dotClick = false;
    graph.click(function(){
        if (dotClick)
            o.dotsClick(dotClick);
    });

    return graph;
}; })(jQuery);