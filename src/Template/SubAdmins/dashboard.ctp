<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li class="active">Home</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
           
          <div class='row'>
            <div class='col-lg-6 col-md-12 col-sm-12'>
             <div class="page_heading">
               <h1>Welcome to <img src="<?php echo $this->request->webroot;?>images/logo-text.png" alt="logo"></h1> 
             </div>
           </div>
           <div class='col-lg-6 col-md-12 col-sm-12' id="actionLinks">
             <a href="#" data-toggle="modal" data-target="#vision" class="customBtn blueBtn">
                Vision
            </a>
          
           <a href="#" data-toggle="modal" data-target="#mission" class="customBtn blueBtn">
               Mission
              </a>
           <a href="#" data-toggle="modal" data-target="#values" class="customBtn blueBtn">
               Values
              </a>
            <a href="#" class="modalLink alignRightlink" data-toggle="modal" data-target="#requirements">Independent Contractor Requirements</a>

            <?php 
              $leanUrl= $this->Url->build(["controller" => "contractors","action" => "leanRoadmaps"]);
            ?> 
           </div>
              
          </div>
           <!-- header ends --> 

          <section id="banner">
             <div id="demo" class="skdslider">
              <ul id="demo1" class="skdslider">
                <li>
                <img src="<?php echo $this->request->webroot;?>images/slide1.png" />
                <!--Slider Description example-->
                 <div class="slide-desc"> 
					<?php if(isset($TopSlidersData[0]['description'])&&($TopSlidersData[0]['description']!='')): ?>
							  <?php echo $TopSlidersData[0]['description']; ?>
				    <?php endif; ?> 
                  </div>
                </li>
                <li><img src="<?php echo $this->request->webroot;?>images/slide2.png" />
                   <div class="slide-desc">
					<?php if(isset($TopSlidersData[1]['description'])&&($TopSlidersData[1]['description']!='')): ?>
							  <?php echo $TopSlidersData[1]['description']; ?>
				    <?php endif; ?> 
                  </div>
                </li>
                <li><img src="<?php echo $this->request->webroot;?>images/slide3.png" />
                  <div class="slide-desc">
					<?php if(isset($TopSlidersData[2]['description'])&&($TopSlidersData[2]['description']!='')): ?>
							  <?php echo $TopSlidersData[2]['description']; ?>
				    <?php endif; ?>
                   
                  </div>
                </li>
              </ul>
            </div>
            
          
           </section>
             
           <!-- banner ends --> 
          
          <!-- actionLinks ends --> 
          <div class="clearfix"></div>
           
            </div>





        <!-- Modal 1-->
<div class="modal fade" id="vision" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Vision</h4>
      </div>
      <div class="modal-body">
        <!--Our vision is the democratization of entrepreneurship by empowering any entrepreneur to transform their idea into initial revenues for close to $0.-->
		<?php if(isset($BlocksData[0]['description'])&&($BlocksData[0]['description']!='')): ?>
		  <?php echo $BlocksData[0]['description']; ?>
		<?php endif; ?>
      </div>
      
    </div>
  </div>
</div>
<!-- Modal 2-->
<div class="modal fade" id="mission" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Mission</h4>
      </div>
      <div class="modal-body">
        <!--Our mission is to circumvent the cultural, geographic, knowledge and financial barriers to entrepreneurship by providing a lean startup roadmap and the resources required for an entrepreneur to bootstrap a startup from idea to initial revenues.-->
		<?php if(isset($BlocksData[1]['description'])&&($BlocksData[1]['description']!='')): ?>
		  <?php echo $BlocksData[1]['description']; ?>
		<?php endif; ?>
      </div>
      
    </div>
  </div>
</div>

<!-- Modal 3-->
<div class="modal fade" id="values" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Values</h4>
      </div>
      <div class="modal-body">
        <!--<p>1. Entrepreneurs: Innovate and execute then work hard to drive success.</p>
        <p>2. Startups: Create and respect intellectual property.</p>
        <p>3. Contractors: Do the right thing and do the thing right.</p>-->
		<?php if(isset($BlocksData[2]['description'])&&($BlocksData[2]['description']!='')): ?>
		  <?php echo $BlocksData[2]['description']; ?>
		<?php endif; ?>
      </div>
      
    </div>
  </div>
</div>
<!-- Modal 4-->
<div class="modal fade" id="requirements" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Independent Contractor Requirements</h4>
      </div>
      <div class="modal-body">
		  <?php if(isset($BlocksData[3]['description'])&&($BlocksData[3]['description']!='')): ?>
		  <?php echo $BlocksData[3]['description']; ?>
		<?php endif; ?>
        <!--You should consult a human resources expert to ensure you are classified as an independent
    consultant not an employee. The following is a link to the IRS tax guide that summarizes the
    common law rules to apply to determine if a worker is an employee or independent contractor <a
        href="https://www.irs.gov/pub/irs-pdf/p15a.pdf">https://www.irs.gov/pub/irs-pdf/p15a.pdf</a>
    <br/>
    <br/>

    In general, you should ensure the startup only has the right to control or direct the result of
    your work and not what you will do and how you will do it. The authorities will consider the
    following to determine your level of control and supervision:
    <ul>
        <li>Whether you invest in your own facilities and operations</li>
        <li>Whether you can make a profit and loss that is distinct from the startup</li>
        <li>The degree of independent initiative, judgment, or foresight that you exercise</li>
        <li>Whether you have a business or organization that is independent of the startup</li>
        <li>The length of your engagement with the startup</li>
        <li>The extent to which your services are integral to the startup’s business</li>
    </ul>

    <ol>
        <li>You should have an occupation or business that is distinct from the startup</li>
        <li>You should not conduct regular business activities for the startup</li>
        <li>You should use your own equipment and tools and work from your own facility.</li>
        <li>You should pay for the equipment and tools required to perform you work</li>
        <li>The services that you provide should be based on a specialized skill that you have.</li>
        <li>You should be a specialist who works without supervision by the Startup.</li>
        <li>Your managerial skill should determine whether you make a profit or loss.</li>
        <li>You should not perform services for the Startup for an extended period of time.</li>
        <li>Your working relationship with the startup should not be permanent.</li>
        <li>You should be compensated by the job and not by time.</li>
        <li>You and the startup must agree that you are not creating an employer-employee
            relationship.
        </li>
    </ol>
    <br/>
    <b>The information above is for general information purposes and is provided to permit you to
        learn more about our service. This information is not legal advice, you should not act on it
        as such, it may not be current and it is subject to change without notice.</b>-->
      </div>
      
    </div>
  </div>
</div>
