<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="login_logout_process.*"%>
<%@ page import="xml_mars_unmars.*"%>
<%@ page import="category.*"%>
<%@ page import="maps.*"%>
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>General HomePage</title>
        <link rel="stylesheet" href="/TED/appearance/css/reset.css" type="text/css" media="screen" />
        <link rel="stylesheet" href="/TED/appearance/css/style_create_item.css" type="text/css" media="screen" />
        <link href="/TED/appearance/css/lightbox.css" rel="stylesheet" />
        <link href="/TED/appearance/css/acordeon.css" rel='stylesheet' type='text/css' />
        <link rel="stylesheet" type="text/css" href="../../css/after_login/auction/create_auction.css">
        <link href='http://fonts.googleapis.com/css?family=Open+Sans|Baumans' rel='stylesheet' type='text/css'/>
        <script src="/TED/appearance/scripts/modernizr.custom.04512.js"></script>
        <script src="/TED/appearance/scripts/respond.js"></script>

        <!-- include extern jQuery file but fall back to local file if extern one fails to load !-->
        <script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
        <script type="text/javascript">window.jQuery || document.write('<script type="text\/javascript" src="js\/1.7.2.jquery.min"><\/script>')</script>

        <script async src="/TED/appearance/scripts/lightbox.js"></script>
        <script src="/TED/appearance/scripts/prefixfree.min.js"></script>
        <script src="/TED/appearance/scripts/jquery.slides.min.js"></script>
        <script src="../../scripts/checkFileSize.js"></script>
		<script src="../../scripts/saveDataAndFill.js"></script>


        <script>
			(function ($, window, document, undefined)
			{
				'use strict';
				$(function ()
				{
					$("#mobileMenu").hide();
					$(".toggleMobile").click(function()
					{
						$(this).toggleClass("active");
						$("#mobileMenu").slideToggle(500);
					});
				});
				$(window).on("resize", function()
				{

					if($(this).width() > 700)
					{
						$("#mobileMenu").hide();
						$(".toggleMobile").removeClass("active");
					}

				});
			})(jQuery, window, document);
		</script>

		<script>
		    var expanded = false;
		    function showCheckboxes() {
		        var checkboxes = document.getElementById("checkboxes");
		        if (!expanded) {
		            checkboxes.style.display = "block";
		            expanded = true;
		        } else {
		            checkboxes.style.display = "none";
		            expanded = false;
		        }
		    }
		</script>

		<script>
		function jqUpdateSize(){
		    // Get the dimensions of the viewport
		    var width = $(window).width();
		    var height = $(window).height();

		    $('#jqWidth').html(width);      // Display the width
		    $('#jqHeight').html(height);    // Display the height

	    	if(width < 700)
	    	{
	    		$(".search2").show();
	    		$(".search").hide();
	    	}
	    	else if(width > 700)
    		{
	    		$(".search2").hide();
	    		$(".search").show();
    		}

		};
		$(document).ready(jqUpdateSize);    // When the page first loads
		$(window).resize(jqUpdateSize);
		</script>


</head>

<body>
<jsp:include page="../../jsp_scripts/header_nav.jsp"/>
<jsp:include page="../../jsp_scripts/search_script.jsp"/>
<%
	LoginSession log = (LoginSession) session.getAttribute("log");
	if(log != null)
	{

		request.setCharacterEncoding("UTF-8");

		String item_name = request.getParameter("item");
		//out.println("<p><b>"+item_name+"</b></p>");
		long item_id = Long.parseLong(item_name);
		Auctions auction = new Auctions(log.getName(),item_id);
		boolean b = auction.checkBidUser();

		Category cat = new Category();
		ResultSet set = cat.get_categories();
		ResultSet item_set = auction.requested_item(item_id);
		ResultSet item_cat = cat.get_item_categories(item_id);
		while (item_set.next())
		{

%>

			        <div id="box_item">

			        <div id="form_title">
			        	<h2 align="center" style="font-size:24px;">Επισκόπηση Δημοπρασίας!</h2>
			        </div>

			        <section id="image_product">
			        	<img src="<%if(item_set.getString("photo_url") != null) out.print(item_set.getString("photo_url"));
			        				else out.print("/TED/img/item3.png");
			        			  %>">

			        </section>

			        <section id="specs">

			        		<p style="font-variant:small-caps; font-family: 'Open Sans', sans-serif;"><label><%out.print(item_set.getString("name"));%>" </label></p>
			                <br/>
			                <p><label>Κατηγορίες :
						        <%
						        while (set.next())
								{
						        	item_cat.beforeFirst();
						        	while (item_cat.next())
									{

						        		if(set.getInt("category_id") == item_cat.getInt("category_id"))
						        		{
						        			out.print(set.getString("value")+", ");
						        		}

									}

						         }
						        %>
						   	</label></p>
							<br/>
			                <p><label>Τωρινή Τιμή : <%out.print(item_set.getString("currently_price"));%> €</label></p>
			                <%
			if(b == false)
			{
%>
			    <form method="post" action="confirm.jsp?item=<%out.print(item_id);%>" >
				    <p><label>Δώστε μία Προσφορά :</label>
					<input type="text" id="bid" name="bid" required/></p>
		            <br/>
		            <input TYPE="submit" name="sub_button" id="sub_button" title="Add data to the Database" value="Προσθήκη"/>
			    </form>
<%
			}
			else
			{
%>
				<p style="color:rgba(255,0,4,1.00);">Έχεις κάνει την τελευταία προσφορά</p>
<%
			}
%>
			                <br/>
			                <p><label>*Τιμή Αγοράς : <%out.print(item_set.getString("buy_price"));%></label></p>
							<br/>
			                <p><label>Ημερομηνία Έναρξης : <%out.print(item_set.getString("start_date"));%></label></p>
							<br/>
			                <p><label>Ημερομηνία Τερματισμού : <%out.print(item_set.getString("end_date"));%></label>
							<br/>

			        </section>
			        <br/>
			        <br/>
			        <br/>

					<div class="container2">
			          <div class="accordion">
			            <dl>
			              <dt>
			                <a href="#accordion1" aria-expanded="false" aria-controls="accordion1" class="accordion-title accordionTitle js-accordionTrigger">Περιγραφή</a>
			              </dt>
			              <dd class="accordion-content accordionItem is-collapsed" id="accordion1" aria-hidden="true">
			                <p><%out.print(item_set.getString("description"));%></p>
			              </dd>
			              <dt>
			                <a href="#accordion2" aria-expanded="false" aria-controls="accordion2" class="accordion-title accordionTitle js-accordionTrigger">
			                  Τοποθεσία</a>
			              </dt>
			              <dd class="accordion-content accordionItem is-collapsed" id="accordion2" aria-hidden="true">

			                <p><label>Χώρα : <%out.print(item_set.getString("country"));%></label></p>
			                <br/>
			                <%
							double latitude = 0;
							double longitude = 0;
							GetLocation2 locations = new GetLocation2(item_id);
							latitude = locations.getLatitude();
							longitude = locations.getLongitude();
							%>
							<iframe
								src="https://www.google.com/maps/embed?pb=!1m17!1m8!1m3!1d
								54734965.0652637!2d
								54.40544131376551!3d
								33.14174419163847!3m2!1i1024!2i768!4f13.1!4m6!3e6!4m0!4m3!3m2!1d
								<%=latitude%>!2d
								<%=longitude%>!5e0!3m2!1sel!2sgr!4v1442404950774"
								width="600" height="450" frameborder="0" style="border:0" allowfullscreen>
							</iframe>
			              </dd>
			            </dl>
			          </div>
			        </div>


			       </div>
<%
		}
	}
	else
	{
		out.println("<center><h1> Guest Mode Permission Denied</h1></center>");
	}
%>
<jsp:include page="../../jsp_scripts/footer.jsp"/>

<script>

		//uses classList, setAttribute, and querySelectorAll
//if you want this to work in IE8/9 youll need to polyfill these
(function(){
	var d = document,
	accordionToggles = d.querySelectorAll('.js-accordionTrigger'),
	setAria,
	setAccordionAria,
	switchAccordion,
  touchSupported = ('ontouchstart' in window),
  pointerSupported = ('pointerdown' in window);

  skipClickDelay = function(e){
    e.preventDefault();
    e.target.click();
  }

		setAriaAttr = function(el, ariaType, newProperty){
		el.setAttribute(ariaType, newProperty);
	};
	setAccordionAria = function(el1, el2, expanded){
		switch(expanded) {
      case "true":
      	setAriaAttr(el1, 'aria-expanded', 'true');
      	setAriaAttr(el2, 'aria-hidden', 'false');
      	break;
      case "false":
      	setAriaAttr(el1, 'aria-expanded', 'false');
      	setAriaAttr(el2, 'aria-hidden', 'true');
      	break;
      default:
				break;
		}
	};
//function
switchAccordion = function(e) {
	e.preventDefault();
	var thisAnswer = e.target.parentNode.nextElementSibling;
	var thisQuestion = e.target;
	if(thisAnswer.classList.contains('is-collapsed')) {
		setAccordionAria(thisQuestion, thisAnswer, 'true');
	} else {
		setAccordionAria(thisQuestion, thisAnswer, 'false');
	}
  	thisQuestion.classList.toggle('is-collapsed');
  	thisQuestion.classList.toggle('is-expanded');
		thisAnswer.classList.toggle('is-collapsed');
		thisAnswer.classList.toggle('is-expanded');

  	thisAnswer.classList.toggle('animateIn');
	};
	for (var i=0,len=accordionToggles.length; i<len; i++) {
		if(touchSupported) {
      accordionToggles[i].addEventListener('touchstart', skipClickDelay, false);
    }
    if(pointerSupported){
      accordionToggles[i].addEventListener('pointerdown', skipClickDelay, false);
    }
    accordionToggles[i].addEventListener('click', switchAccordion, false);
  }
})();

</script>


</body>
</html>