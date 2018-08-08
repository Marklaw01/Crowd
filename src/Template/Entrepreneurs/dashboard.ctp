<div class="container-fluid">
          <div class="row">
            <div class='col-lg-12 col-md-12 col-sm-12 '>
              <div class="profileName profileNameFeeds <?php echo $widthClass;?>">
                  
                  <?php
                      echo $this->Html->link('Home', array('controller'=>'Entrepreneurs','action'=>'dashboard'), array('escape'=>false,'class'=>'active'));
                  ?>

                  <?php
                      echo $this->Html->link("News", array('controller'=>'Contractors','action'=>'news'), array('escape'=>false,'class'=>'navbar-brand'));
                  ?>

                  <?php 
                    if(!empty($UserId)){
                      echo $this->Html->link("Alerts", array('controller'=>'Contractors','action'=>'feeds'), array('escape'=>false,'class'=>'navbar-brand'));
                    }
                  ?>

                  <?php
                    if(!empty($UserId)){
                      echo $this->Html->link("Networking Options", array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false,'class'=>'navbar-brand'));
                    }
                  ?>
              </div>
            </div>
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li class="active">Home</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
           <div class='row'>
            
             <div class='col-lg-12 col-md-12 col-sm-12 '>
              <div class="profileName">
              	  <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/professional.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'ENTREPRENEUR', array('controller'=>'Entrepreneurs','action'=>'dashboard'), array('escape'=>false,'class'=>'navbar-brand active'));
                  ?>
                  <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/users.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'CONTRACTOR', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>''));
                  ?>
              </div>

            </div>
             
          </div>
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
            <a href="<?php echo $leanUrl;?>" class="modalLink alignRightlink leanMap">Lean Startup Roadmap <sup>R</sup></a>
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
                    <p><span>Crowd <span>Bootstrap</span></span> is a pre-accelerator that 
                    provides you the resources to bootstrap your startup.</p>

                    <p>The goal is to minimize the time, cost and risk to transform your startup idea into revenues.</p>
                  </div>
                </li>
                <li><img src="<?php echo $this->request->webroot;?>images/slide2.png" />
                   <div class="slide-desc">
                    <p><span>Crowd<span> Bootstrap</span></span> is a pre-accelerator that 
                    provides you the resources to bootstrap your startup.</p>

                    <p>The goal is to minimize the time, cost and risk to transform your startup idea into revenues.</p>
                  </div>
                </li>
                <li><img src="<?php echo $this->request->webroot;?>images/slide3.png" />
                  <div class="slide-desc">
                    <p><span>Crowd<span> Bootstrap</span></span> is a pre-accelerator that 
                    provides you the resources to bootstrap your startup.</p>

                    <p>The goal is to minimize the time, cost and risk to transform your startup idea into revenues.</p>
                  </div>
                </li>
              </ul>
            </div>
            
          
           </section>
             
           <!-- banner ends --> 
          
          <!-- actionLinks ends --> 
          <div class="clearfix"></div>
           <section id="howItWorks">
            <div class="section_heading">
               <a href="#" data-toggle="modal" data-target="#howitworks" class="" style="color: #03375c;">
                <h1>Here's How it Works</h1> 
              </a>
            </div>
            
            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12 work-process">
              <a href="#">
                 <span class="fa fa-pencil"></span> 
                 <p class="step1">Submit<br>
                 your startup</p>
               </a>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12 work-process">
              <a href="#">
                 <span class="fa  fa-hand-o-right"></span> 
                 <p class="step2">
                 Follow our lean <br> 
                 startup process.</p>
              </a>
            </div>
            
            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12 work-process">
              <a href="#">
                <span class="fa  fa-users"></span>
                <p class="step3">Experts Help You <br>
              Complete Startup Activities </p>
              </a>
            </div>
            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 work-process">
              <a href="#">
                <span class="handshake"></span> 
                <p class="step4">
                Leverage <br>
                communal resources</p>
            </a>
            </div>
            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 work-process">
              <a href="#">
                <span class="fa fa-cogs"></span> 
               <p class="step5">Launch <br>
               and Gain Traction</p>
              </a>
            </div>
            <div class="clearfix"></div>
           

          </section>
           <!-- howitworks ends -->  

           <section id="features">
             <div class="row">
               <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 ">
                 <div class="section_heading">
                    <h1>Special Features</h1> 
                 </div>
                 <div id="carousel-example-generic" class="carousel slide" data-ride="carousel" data-interval="10000">
 
                    <!-- Wrapper for slides -->
                    <div class="carousel-inner" role="listbox">
                      <?php if(isset($BottomSlidersData)&&(!empty($BottomSlidersData))):?>
                        <?php foreach($BottomSlidersData as $key=>$singleBottomData): ?>
                        <div class="item <?php if($key=='0'):echo 'active'; endif;?>">
                            <div class="featureBlock">
                            <div class="icon">
                                  <?php if(isset($singleBottomData->image)
                                    &&($singleBottomData->image!='')): ?>
                                      
                                      <img src="<?php echo $this->request->webroot.'img/sliderimages/'.$singleBottomData->image; ?>"  alt="">
                                      
                                  <?php endif; ?>
                            </div>
                            <h2>
                                 <?php if(isset($singleBottomData->title)
                                    &&($singleBottomData->title!='')): ?>
                                  
                                  <?php echo $singleBottomData->title; ?>
                                  
                                 <?php endif; ?>
                            </h2> 
                            <!--<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque pellentesque tincidunt dui, ac viverra dolor placerat ut. Nullam congue finibus finibus. Vestibulum viverra libero odio. </p>-->
                            <?php if(isset($singleBottomData->description)
                                    &&($singleBottomData->description!='')): ?>
                                  
                                  <p><?php echo $singleBottomData->description; ?></p>
                                  
                            <?php endif; ?>
                            </div>
                        </div>
                        <?php endforeach; ?>
                      <?php endif; ?>
                     
                  </div>

                      <!-- Controls -->
                      <div class="arrow-controls">
                      <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
                        <span class="fa fa-angle-left" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                      </a>
                      <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
                        <span class="fa fa-angle-right " aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                      </a>
                      </div>
                    </div> <!-- Controls -->
                                  
               </div> 
               <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 ">
                 <div class="section_heading">
                    <h1>Explainer Video</h1> 
                 </div>
                 <iframe width="459" height="354" src="https://www.youtube.com/embed/t4qOmcKPsC0" frameborder="0" allowfullscreen></iframe>
                  <video width="" height="" controls style="display: none !important;">
                    <source src="video/movie.mp4" type="video/mp4">
                    <source src="movie.ogg" type="video/ogg">
                    Your browser does not support the video tag.
                  </video>

               </div>
             </div> 

          </section>
         
       
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
        Our vision is the democratization of entrepreneurship by empowering any entrepreneur to transform their idea into initial revenues for close to $0.
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
        Our mission is to circumvent the cultural, geographic, knowledge and financial barriers to entrepreneurship by providing a lean startup roadmap and the resources required for an entrepreneur to bootstrap a startup from idea to initial revenues.
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
         <p>1. Entrepreneurs: Innovate and execute then work hard to drive success.</p>
         <p>2. Startups: Create and respect intellectual property.</p>
         <p>3. Contractors: Do the right thing and do the thing right.</p>
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
       You should consult a human resources expert to ensure you are classified as an independent
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
        as such, it may not be current and it is subject to change without notice.</b>
      </div>
      
    </div>
  </div>
</div>

<div class="modal fade" id="howitworks" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Here's How it Works</h4>
      </div>
      <div class="modal-body">
        An entrepreneur submits a startup to Crowd Bootstrap. If that startup attracts sufficient interest from the crowd of contractors then Crowd Bootstrap invests $100,000 of the contractors\' sweat equity for a 10% stake in the startup. Crowd Bootstrap helps match entrepreneurs and contractors. Contractors help entrepreneurs complete startup deliverables. This is formalized by the contractor submitting a deliverable-based timesheet for approval. After the entrepreneur approves the timesheet, the contractor receives share options in the corresponding Crowd Bootstrap fund. The contractor\'s stake is therefore diversified across all of the startup\'s in that fund\'s portfolio. Crowd Bootstrap does not charge the entrepreneurs or contractors for this service.
      </div>
      
    </div>
  </div>
</div>