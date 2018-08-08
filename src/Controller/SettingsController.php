<?php

namespace App\Controller;

use App\Controller\AppController;
use Cake\Auth\DefaultPasswordHasher;
use Cake\ORM\TableRegistry;
use Cake\Mailer\Email;
use Cake\Event\Event;


/**
 * Users Controller
 *
 * @property \App\Model\Table\UsersTable $Users
 */
class SettingsController extends AppController
{

	public function beforeFilter(\Cake\Event\Event $event)
	{
		$this->Auth->allow(['index']);
	}

	/**
	 * Index method
	 *
	 * @return void
	 **/

	public function index()
	{
		$this->viewBuilder()->layout(false);


$ApiList[] = '<h3>Login</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/login
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> email(user"s email),password (user"s, passwords), access_token, device_token, device_type</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"user_id":2,"first_name":"XXXX","last_name":"XXX","email":"example@gmail.com","username":"xxx.xxx","date_of_birth":"19\/06\/2015","phoneno":1234567891,"user_image":"\/img\/default\/userdummy.jpg","message":"Success"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Your username or password is incorrect"}</span></div>
                    </div>';
$ApiList[] = '<h3>Max Limit for Reset Pass</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/maxLimitResetPass
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> email_id(user"s email id)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"message":"Exceeded recover password limit Please contact site administrator."}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"No Email address found."}</span></div>
                    </div>';
		 		
$ApiList[] = '<h3>Logout</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/logout
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(user"s id),access_token,device_token,device_type</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"message":"Success"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Incorrect tokens"}</span></div>
                    </div>';
$ApiList[] = '<h3>Register</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/logout
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> quickbloxid, username,first_name,last_name,email,password,confirm_password,date_of_birth,phoneno,country(country code),state(state code),best_availablity,predefined_questions(Array lsit of predefinded question id and answers),own_questions(Array of question and answer added by user)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"message":"Success"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Errors","errors":{"username":"This value is already in use","email":"This value is already in use"}}</span></div>
                    </div>';

		
		$ApiList[] = '<h3>Countries List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/AppcountryList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> No Parameters</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"country":[{"id":1,"name":"Afghanistan"},{"id":246,"name":"Zimbabwe"}]}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{code:404,message:No Countries Found}</span></div>
                    </div>';
		 		
		
		$ApiList[] = '<h3>States List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/AppstateList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> country_id(Country"s id)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"state":[{"id":1,"name":"Andaman and Nicobar Islands"},{"id":9,"name":"Daman and Diu"}]}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{code:404,message:No States Found}</span></div>
                    </div>';
		
		$ApiList[] = '<h3>Questions List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/AppquestionList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> No Parameters</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"question":[{"id":1,"name":"What is the last name of the teacher who gave you your first failing grade?"},{"id":2,"name":"What was the name of your elementary \/ primary school?"},{"id":3,"name":"In what city or town does your nearest sibling live?"},{"id":4,"name":"What time of the day were you born? (hh:mm)"}]}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{code:404,message:No Questions Found}</span></div>
                    </div>';
					
		$ApiList[] = '<h3>User Questions List (In Reset Password Page)</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/AppuserQuestionList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_email(User"s email)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{
						"code": 200,
						"questionAnswers": [{
							"question": "What is the last name of the teacher who gave you your first failing grade?",
							"answer": "ss"
						}, {
							"question": "In what city or town does your nearest sibling live?",
							"answer": "vv"
						}, {
							"question": "Favourite cricket player?",
							"answer": "Ponting"
						}, {
							"question": "Favourite cricket team?",
							"answer": "Aus"
						}]
					}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"No Questions Found"}</span></div>
                    </div>';
			
			$ApiList[] = '<h3>Contractor Basic profile </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/userContractorBasic
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User"s id),logged_in_user(currently logged in user)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{
						"code": 200,
						"name": "Vijay Kumar",
						"profile_image": "\/img\/profile_pic\/1456296757_239615.jpg",
						"rating": "4.0000",
						"profile_completeness": " ",
						"isFollowing":"1",
						"perhour_rate": 12.25,
						"basic_information": {
							"biodata": "MCA ",
							"name": "Vijay Kumar",
							"email": "vijaykumar@gmail.com",
							"dob": "19\/03\/2016",
							"phone": 1234567891,
							"city": "chd",
							"country": 101
						}
					}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Profile Not Found"}</span></div>
                    </div>';
				
				$ApiList[] = '<h3>Contractor Proffessional profile </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/userContractorProffesional
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User"s id),logged_in_user(currently logged in user)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{
						"code": 200,
						"name": "Vijay Kumar",
						"rating": "4.0000",
						"profile_image": "\/img\/profile_pic\/1456296757_239615.jpg",
						"profile_completeness": " ",
						"isFollowing":"1",
						"professional_information": {
							"experience": "5",
							"keywords": "keyword one,keyword two",
							"qualifications": "qualification two",
							"certifications": "certification one,certification two",
							"skills": "skill one,skill two",
							"industry_focus": " ",
							"contractor_type": "contracter type two",
							"preferred_startup": "preffered startup one"
						}
					}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Profile Not Found"}</span></div>
                    </div>';
				
				$ApiList[] = '<h3>Entrepreneur Basic profile </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/userEntrepreneurBasic
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User"s id),logged_in_user(currently logged in user)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{
						"code": 200,
						"profile_image": "\/img\/default\/userdummy.jpg",
						"rating": "4.0000",
						"profile_completeness": " ",
						"isFollowing":"1",
						"basic_information": {
							"biodata": "entrepreneur bio",
							"name": "vijay kumar",
							"email": "vijaykumar99@gmail.com",
							"dob": " ",
							"phone": 2147483647,
							"city_id": 6,
							"city": "Chandigarh",
							"country_id": 101,
							"country": "India",
							"interest": "music"
						}
					}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Profile Not Found"}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>Entrepreneur Proffessional profile </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/userEntrepreneurProfessional
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User"s id),logged_in_user(currently logged in user)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{
					   "code": 200,
					   "profile_image": "\/img\/default\/userdummy.jpg",
					   "rating": "4.0000",
					   "profile_completeness": " ",
					   isFollowing:"1",
					   "professional_information": {
						   "name": "Vijay Kumar",
						   "experience": "5",
						   "keywords": [{
							   "id": 1,
							   "name": "keyword one"
						   }, {
							   "id": 2,
							   "name": "keyword two"
						   }],
						   "qualifications": [{
							   "id": 2,
							   "name": "qualification two"
						   }],
						   "certifications": [{
							   "id": 1,
							   "name": "certification one"
						   }, {
							   "id": 2,
							   "name": "certification two"
						   }],
						   "skills": [{
							   "id": 1,
							   "name": "skill one"
						   }],
						   "industry_focus": "main focus",
						   "contractor_type": "contracter type two",
						   "contractor_type_id": "2",
						   "preferred_startup": "preffered startup one",
						   "preferred_startup_id": "1"
					   }
				   }
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Profile Not Found"}</span></div>
                    </div>';
					
			$ApiList[] = '<h3>Skills, keywords,qualification etc</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/SQKCCPE
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">no Parameters</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{
						"keywords": [
							{
								"id": 3,
								"name": "keyword one"
							},
							{
								"id": 4,
								"name": "keyword two"
							}
						],
						"experiences": [
							{
								"id": 1,
								"name": "1 Year"
							},
							{
								"id": 2,
								"name": "2 Year"
							},
							{
								"id": 3,
								"name": "3 Year"
							},
							{
								"id": 4,
								"name": "4 Year"
							}
						],
						"skills": [
							{
								"id": 1,
								"name": "skill one"
							},
							{
								"id": 2,
								"name": "skill two"
							}
						],
						"qualifications": [
							{
								"id": 1,
								"name": "qualification one"
							},
							{
								"id": 2,
								"name": "qualification two"
							}
						],
						"prefferStartups": [
							{
								"id": 1,
								"name": "preffered startup one"
							},
							{
								"id": 2,
								"name": "preffered startup two"
							}
						],
						"contractorTypes": [
							{
								"id": 1,
								"name": "contracter type one"
							},
							{
								"id": 2,
								"name": "contracter type two"
							}
						],
						"certifications": [
							{
								"id": 1,
								"name": "certification one"
							},
							{
								"id": 2,
								"name": "certification two"
							}
						]
					}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Profile Not Found"}</span></div>
                    </div>';
				
				
				$ApiList[] = '<h3>Contractor Basic Edit Profile</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/editContractorBasic
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(User"s Id), price(Rate per hour), bio(User Bio),
					first_name(User first name), last_name(User last name), email(user email), date_of_birth(DOB),
					country_id(Country Id), state_id(State ID), phoneno(Phone Nunmber), image(contractor Image for basic profile)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"profile_completeness":" ","message":"Successfully Updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"errors":{"bio":"This field cannot be left empty"}}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Entrepreneur Basic Edit Profile</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/editEntrepreneurBasic
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(User"s Id), my_interests(Users"s interests), bio(User Bio),
					first_name(User first name), last_name(User last name), email(user email), date_of_birth(DOB),
					country_id(Country Id), state_id(State ID), phoneno(Phone Nunmber), image(Entrepreneur Image for basic profile)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"profile_completeness":" ","message":"Successfully Updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"errors":{"bio":"This field cannot be left empty"}}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>contractor professional Edit Profile</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/editContractorProffesional
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(User"s Id), image(Users"s image), rate(User per hour price),
					experience_id(experience), keywords(keywords), qualifications(qualifications), certifications(certifications),
					skills(skills), industry_focus(industry_focus), first_name(first name), last_name(last name), startup_stage(startup stage), contributor_type(contributor type), accredited_investor(accredited investor)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"profile_completeness":" ","message":"Successfully Updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"errors":{"bio":"This field cannot be left empty"}}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Entrepreneur professional Edit Profile</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/editEntrepreneurProffesional
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(User"s Id), company_name(company name), website_link(company link),
					description(description), keywords(keywords), qualifications(qualifications), 
					skills(skills), industry_focus(industry focus), first_name(first name), last_name(last name), image(image)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"image":"\/img\/profile_pic\/1458194402_480264.jpg","profile_completeness":" ","message":"Successfully Updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"errors":{"bio":"This field cannot be left empty"}}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>User Startups list</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/userStartup
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),user_type[ENTREPRENEUR,CONTRACTOR](user type)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":"200","startup":[{"id":1,"name":"start up one","description":"lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum.","isSelected":"true"},{"id":2,"name":"start up two","description":"lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum.","isSelected":"false"}]}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":"404","message":"No startups available"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Profile setting</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/profileSettings
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),public_profile[true,false](to make profile public or private)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":"404","message":"Not updated"}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>adding startup</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addStartupList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),user_type[ENTREPRENEUR,CONTRACTOR](user type),startup_id(startup ids)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":"200","message":"successfully updated"}]}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":"404","message":"Not updated"}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>user startup after adding startup</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/userSelectedStartup
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),user_type[ENTREPRENEUR,CONTRACTOR](user type)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":"200","startup":[{"id":1,"name":"start up one","description":"lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum."},{"id":2,"name":"start up two","description":"lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum."}]}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":"404","message":"No Startup found"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>user keywords</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/keywords
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">No parameters</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"keywords":[{"id":3,"name":"keyword one"},{"id":4,"name":"keyword two"}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":"404","message":"No Startup found"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Add startup</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addStartup
                    </br>
					<div><b>Request Type:-</b><span  class="input-param"> POST(jSon)</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(User id),name(Startup name),description(Startup description),keywords(Keywords),support_required(Support required)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"keywords":[{"id":3,"name":"keyword one"},{"id":4,"name":"keyword two"}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":"404","message":"No Startup found"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Campaigns list</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/campaignsList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(User id),page_no(Page number for the pagination),campaign_type(“0” for Recommended, “1” for Following, “2” for Commitments, “3” for My Campaigns)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"campaigns":[{"campaign_id":1,"campaign_name":"first campaign","startup_name":"start up one","startup_id":1,"target_amount":100,"fund_raised":10,"description":"summary is here","due_date":null},{"campaign_id":2,"campaign_name":"first campaign","startup_name":"start up one","startup_id":1,"target_amount":100,"fund_raised":10,"description":"summary is here","due_date":null}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"campaigns":[]}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Timeperiods list</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/timePeriods
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">NO parameters</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"DonationTimeperiods":[{"id":1,"name":"15 Days"},{"id":2,"name":"30 Days"},{"id":3,"name":"2 Months"},{"id":4,"name":"6 Months"},{"id":5,"name":"12 Months"},{"id":6,"name":"2 Years"}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"DonationTimeperiods":[]}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Commit Campaign</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/commitCampaign
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id,(user id),campaign_id(campaign id),target_amount(target amount),time_period(time period),contribution_public(public{false},private{true})</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully saved"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":200,"message":"not saved"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Add Campaign</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addCampaign
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id,(user id),startup_id(startup id),
					summary(description),target_amount(time period),fund_raised_so_far(fund raised),due_date(due date),keywords(Keywords id),
					campaign_image(campaign image),docs[](documents files)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully saved"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":200,"message":"not saved"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Edit Campaign</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/editCampaign
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">id(campaign id), user_id,(user id),startup_id(startup id),
					summary(description),target_amount(time period),fund_raised_so_far(fund raised),due_date(due date),keywords(Keywords id),
					campaign_image(campaign image),docs[](documents files),deleted_files(comma seperated docs names that have to be deleted)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":200,"message":"not updated"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>single Campaign detail</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/singleCampaignDetail
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">campaign_id(campaign id), user_id,(user id)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{
							"code": 200,
							"campaigndetail": {
								"campaign_id": 9,
								"campaigns_name": "my updated campaign",
								"startup_id": 1,
								"startup_name": "start up one",
								"due_date": "Apr 30, 2016",
								"target_amount": 1000,
								"fund_raised_so_far": 100,
								"summary": "just summary updated",
								"campaign_image": "img/campaign/1460029244_487918nas-400x295-1.jpg",
								"keywords": [
									{
										"name": "keyword one"
									},
									{
										"name": "keyword two"
									}
								],
								"documents_list": [
									{
										"file": "img/campaign/1460096179_110801Api List.doc"
									},
									{
										"file": "img/campaign/1460096179_110801Api List.docx"
									},
									{
										"file": "img/campaign/1460096179_110801Api List.pdf"
									}
								],
								"audios_list": [
									{
										"file": "img/campaign/1460097153_427977Api List.mp3"
									}
								],
								"videos_list": [
									{
										"file": "img/campaign/1460098677_534874new.mp4"
									}
								],
								"is_follwed_by_user": "1",
								"is_commited_by_user": "0"
							}
						}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"campaigndetail":[]}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>UnCommit Campaign</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/uncommitCampaign
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id,(user id),campaign_id(campaign id)</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully uncommited"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"can"t uncommit"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Follow and Unfollow Campaign</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/followCampaign
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id,(user id),campaign_id(campaign id),
												status([true{to follow},false{to unfollow}])</span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully followed"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"can"t follow"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>campaign contractor list</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/campaignContributorsList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> campaign_id(campaign id),
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"campaignContributorsList":[{"contractor_name":"vijay ","contractor_id":7,"contractor_image":"\/img\/profile_pic\/1458126343_205545.jpg","contractor_contribution":150,"status":0},{"contractor_name":"Neel Karn","contractor_id":3,"contractor_image":"\/img\/default\/userdummy.png","contractor_contribution":100,"status":1}]}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"campaignContributorsList":[]}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>startups list</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupsList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User id),startup_type([ist 0-->"Current Startups", 1-->"Completed Startups", 2-->"Search Startups", 3-->"My Startups"],
					page_no(for pagination),search_text(search text)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{
							"TotalItems": 1,
							"startups": [
								{
									"startup_id": 1,
									"entrepreneur_id": 10,
									"entrepreneur_name": "Mark Law",
									"startup_name": "start up one",
									"startup_desc": "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum.",
									"is_entrepreneur": "false",
									"is_contractor": "true"
								}
							],
							"code": 200
						}
					</span></div>
                    </br>
					Note:- 1=> Approved, 0=> Not Approved, 2=>suspended,3=>removed
                    <div><b>Error:-</b><span class="input-param">{"code":404,"startups":[],"TotalItems": 0}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Startup overview</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupOverview
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User id),startup_id(startup id)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"startup_id":2,"startup_name":" ","startup_desc":"lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum.","entrepreneur_id":7,"entrepreneur_name":"neeel karn","roadmap_grapic":"img\/roadmap\/1460007016_915824carjpg.jpeg","support_required":"yes req","next_step":"","roadmap_deliverable_list":[{"deliverable_id":1,"deliverable_name":"Deliverable 1","deliverable_link":"img\/roadmap\/1460007016_915824carjpg.jpeg"},{"deliverable_id":2,"deliverable_name":"Deliverable 2","deliverable_link":""}],"keywords":[{"id":3,"name":"keyword one"},{"id":4,"name":"keyword two"}],"code":200}
					</span></div>
                    </br>
					
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"detail not found"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Team Members</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupTeam
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User id),startup_id(startup id)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"startup_id":2,"team_member":[{"team_memberid":7,"member_name":"neeel karn","member_role":"Entrepreneur","member_bio":"bio","member_email":"vijay@gmail.com","member_status":2},{"team_memberid":7,"member_name":"vijay ","member_role":"Team-member","member_bio":"bio","member_email":"vijay@gmail.com","member_status":1}],"code":404}
					</span></div>
                    </br>
					
                    <div><b>Error:-</b><span class="input-param">{"code":404,"team_member":[]}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>startup Work orders</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupWorkorders
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(User id),startup_id(startup id),
														date(Ex - 12 Apr, 2016),day(ex- Mon)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{
							"startup_id": 2,
							"teammember_id": 7,
							"Allocated_hours": 50,
							"Approved_hours": 10,
							"weekly_update": [
								{
									"date": "2016-04-11",
									"deliverables": [
										{
											"work_orderid": 3,
											"deliverable_name": "Deliverable 3",
											"work_units": 6
										},
										{
											"work_orderid": 4,
											"deliverable_name": [],
											"work_units": 2
										}
									]
								},
								{
									"date": "2016-04-12",
									"deliverables": []
								},
								{
									"date": "2016-04-13",
									"deliverables": [
										{
											"work_orderid": 2,
											"deliverable_name": "Deliverable 2",
											"work_units": 3
										}
									]
								},
								{
									"date": "2016-04-14",
									"deliverables": [
										{
											"work_orderid": 1,
											"deliverable_name": "Deliverable 1",
											"work_units": 10
										}
									]
								},
								{
									"date": "2016-04-15",
									"deliverables": [
										{
											"work_orderid": 5,
											"deliverable_name": [],
											"work_units": 2
										}
									]
								},
								{
									"date": "2016-04-16",
									"deliverables": []
								},
								{
									"date": "2016-04-17",
									"deliverables": [
										{
											"work_orderid": 6,
											"deliverable_name": [],
											"work_units": 2
										}
									]
								}
							],
							"code": 200
						}
					</span></div>
                    </br>
                    </div>';
					
						
					$ApiList[] = '<h3>Team member status</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/teamMemberStatus
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(user id),startup_id(startup id),
																			status(2-->suspended,1-->resumed,3-->remove)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"Team member removed"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Team member not removed"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Send message</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/sendMessage
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> from_team_memberid(sender id),to_team_memberid(receiver id),
																			subject(subject of the message),message_text(message)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"Message successfully sent"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Message not sent"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>entrepreneur Workorder</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/entrepreneurWorkorders
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> user_id(user id),startup_id(startup id)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{
						"workOrders": [
							{
								"team_memberid": 7,
								"work_orderid": 3,
								"date": "April 11, 2016",
								"work_units": 6,
								"member_name": "neeel karn",
								"roadmap_name": "Deliverable 3"
							},
							{
								"team_memberid": 7,
								"work_orderid": 4,
								"date": "April 11, 2016",
								"work_units": 2,
								"member_name": "neeel karn",
								"roadmap_name": ""
							},
							{
								"team_memberid": 7,
								"work_orderid": 5,
								"date": "April 15, 2016",
								"work_units": 2,
								"member_name": "neeel karn",
								"roadmap_name": ""
							},
							{
								"team_memberid": 7,
								"work_orderid": 6,
								"date": "April 17, 2016",
								"work_units": 2,
								"member_name": "neeel karn",
								"roadmap_name": ""
							}
						],
						"code": 200
					}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"workOrders":[]}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>update/delete workorder Status </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/workorderStatus
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> status(1-->activate,0-->delete),workorder_id(work order id)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully deleted"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":200,"message":"not deleted"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>update Startup </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/updateStartup
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[entity]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param"> id(startup id),name(startup name),
												description(description),next_step(next step),keywords(keywords),support_required(support required)
												roadmap_graphic(Roadmap Graphic)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"successfully updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":200,"message":"not updated"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>update workorder </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/updateWorkorder
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">{
																		"Approved": {
																			"user_id": "7",
																			"startup_id": "2",
																			"roadmap_id": "4",
																			"work_date": "Apr 29,2016",
																			"workunit": "100"
																		},
																		"Pending": {
																			"user_id": "7",
																			"startup_id": "2",
																			"roadmap_id": "2",
																			"work_date": "Apr 31,2016",
																			"workunit": "40"
																		}
																	}
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"Workorder updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Workorder not updated"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>deliverables list </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/allDeliverables
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">No parameters
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"Deliverables":[{"id":1,"name":"Deliverable 1"},{"id":2,"name":"Deliverable 2"},{"id":3,"name":"Deliverable 3"}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"Deliverables":[],"code":400}</span></div>
                    </div>';

					
					$ApiList[] = '<h3>upload startup docs</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/uploadRoadmapDocs
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[entity]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">name(file name),user_id(logged in user id),
												startup_id(startup id),roadmap_id(roadmap id),file_path(file to be upload),
												access(comma seperated users id),public(0-->public,1-->private)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"Document successfully uploaded"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":200,"message":"Document not uploaded"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>deliverables Docs List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deliverablesDocsList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"filesList":[{"id":2,"date":null,"doc_name":"1461236072_957869justadb.pdf","download_link":"img\/roadmap\/1461236072_957869justadb.pdf","roadmap_name":"Deliverable 1","user_name":"neeel karn"},{"id":3,"date":null,"doc_name":"1461236072_957868justadb.pdf","download_link":"img\/roadmap\/1461236072_957868justadb.pdf","roadmap_name":"Deliverable 1","user_name":"Neel Karn"}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"filesList":[],"code":400}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>recommended Contractors List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/recommendedContractors
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"TotalItems":2,"Contractors":[{"id":7,"name":"vijay ","image":"\/img\/profile_pic\/1458126343_205545.jpg","rate":"","skills":[{"id":1,"name":"skill one"}],"keywords":[]},{"id":8,"name":"Vijay Kumar","image":"\/img\/default\/userdummy.png","rate":"","skills":[{"id":1,"name":"skill one"},{"id":1,"name":"skill one"}],"keywords":[]}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"TotalItems":"0","Contractors":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>searched Contractors List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/searchContractors
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(entrepreneur/loggedin user id),
																	search_text(search text),page_no(Page number)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"TotalItems":1,"Contractors":[{"id":8,"name":"Vijay Kumar","image":"\/img\/default\/userdummy.png","bio":"","rate":"","skills":[{"id":1,"name":"skill one"}],"keywords":[{"id":3,"name":"keyword one"}]}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"TotalItems":"0","Contractors":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>add TeamMember</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addTeamMember
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id),user_id(user id),
																			contractor_role_id(team member role),hourly_price(member rate),
																			roadmap_id(deliverable),work_units_allocated(hours allocated)
																			,work_units_approved(approved hours)}

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"Team Member successfully added"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Team Member not added"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>add Rating</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/rateContractor
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">given_by(id of user who is giving the rating),given_to(id of user to whom rating is given),
																			description(descrioption),rating_star(rating),
																			deliverable(deliverable[comma seperated])

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"Successfully rated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"not rated"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>teamMembers Roles</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/teamMembersRoles
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">No parameters

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"Roles":[{"id":1,"name":"Entrepreneur"},{"id":2,"name":"Co-founder"},{"id":3,"name":"Team-member"},{"id":4,"name":"Contractor"}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"Roles":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>delete Startup</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deleteStartup
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(start up id)

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"startup deleted"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"startup not deleted"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>delete Campaign</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deleteCampaign
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">campaign_id(campaign id)

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
					{"code":200,"message":"Campaign deleted"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Campaign not deleted"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>all Ratings of a user</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/allRatings
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id whose ratings you want)

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
										{
						"Ratings": [
							{
								"givenby_id": 1,
								"givenby_name": "shivani pareek",
								"givenby_image": "/img/default/userdummy.png",
								"description": "description 1",
								"rating": 3,
								"date": "April 26, 2016"
							},
							{
								"givenby_id": 2,
								"givenby_name": "Vijay Kumar",
								"givenby_image": "/img/default/userdummy.png",
								"description": "description 2",
								"rating": 5,
								"date": "April 24, 2016"
							}
						],
						"code": 200
					}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{
									"Ratings": [],
									"code": 404
								}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>Completed roadmaps of a startup</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupRoadmapsStaus
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id)

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
										{
											"CompletedRoadmaps": [
												{
													"roadmap_id": 1,
													"roadmap_name": "Deliverable 1"
												},
												{
													"roadmap_id": 2,
													"roadmap_name": "Deliverable 2"
												}
											],
											"code": 200
										}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{
									"CompletedRoadmaps": [],
									"code": 404
								}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>update startup roadmap</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/updateStartupRoadmap
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[entity]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id),
																			user_id(user id),preffered_startup_stage(preffered startup stage[string])
																			current_roadmap(roadmap id),file_path(doc file),complete([0->NO,1->Yes]),next_step(string)

												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
										{"code":200,"message":"startup roadmap successfully updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">	{"code":404,"message":"startup roadmap not updated"}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>upload Startup Profile</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/uploadStartupProfile
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[entity]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id),
																			user_id(user id),file_name(file name),
																			file_path(doc file),status([0,1])
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
										{"code":200,"message":"startup profile successfully updated"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">	{"code":404,"message":"startup profile not updated"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Download Contractor excel</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/Contractorexcel
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),startup_id(start id),
																			date(date),"day(day name)
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
										{"code":200,"file_path":"\/opt\/lampp\/htdocs\/crowdbootstarp\/webroot\/excel_files\/test.xlsx"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">	{"code":404,"message":"No file found"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Download Entrepreneur excel</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/Entrepreneurexcel
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(start id)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
										{"code":200,"file_path":"\/opt\/lampp\/htdocs\/crowdbootstarp\/webroot\/excel_files\/test.xlsx"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">	{"code":404,"message":"No file found"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>startup Questions</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupQuestions
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(start id),
																			questions(questions object),is_submited(0 or1)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
									{"code":200,"message":"startup questions successfully saved"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">	{"code":404,"message":"startup questions not saved"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>user Follow</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/userFollow
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">followed_by(follower user id),
																			user_id(the user who is getting followed),status([1-->follow,0-->UnFollow])
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
									{"code":200,"message":"Successfully following"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">	{"code":404,"message":"Can"t follow"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Messages List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/messagesList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(id of user who received messages),
					page_no(page number for pagination)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
									{"Messages":[{"id":1,"title":"this is subject","description":"lorem ipsum","sender":"Vijay Kumar","time":null},{"id":2,"title":"this is subject","description":"lorem ipsum","sender":"vijay hhhh","time":null}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"Messages":[],"code":404}</span></div>
                    </div>';
					
					
					
					$ApiList[] = '<h3>message Archived Delete</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/messageArchivedDelete
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">message_id(id of message to archived or deleted),
																			status([1-->archived,2-->deleted])
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
								{"code":200,"message":"Message is Archived"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Message is not Archived"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>My Forums List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/myForums
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(id of user who created forums),page_no(page number for pagination)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
														{
							"Forums": [
								{
									"id": 1,
									"forum_title": "forum one title",
									"description": "lorem ipsum",
									"forumCreatedBy": "Vijay Kumar",
									"createdTime": null
								},
								{
									"id": 2,
									"forum_title": "forum two title",
									"description": "lorem ipsum",
									"forumCreatedBy": "Vijay Kumar",
									"createdTime": null
								},
								{
									"id": 3,
									"forum_title": "forum three title",
									"description": "lorem ipsum",
									"forumCreatedBy": "Vijay Kumar",
									"createdTime": null
								}
							],
							"code": 200
						}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"Forums":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>forum Archived Delete</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/forumArchivedDelete
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">forum_id(id of forum to archived or deleted),
																			status([1-->archived,2-->deleted,3-->close])
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
								{"code":200,"message":"forum is Archived"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"forum is not Archived"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>add Forum</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addForum
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[entity]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id),
																			user_id(user id),title(forum title),keywords(keywords),
																			image(image of forum),description(description)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
								{"code":200,"message":"Forum successfully created"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"Forum not created"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>forum Startups List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/forumStartupsList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),page_no(page number)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
							{"TotalItems":2,"startups":[{"startup_id":2,"startup_name":"updated name","description":"updated descrition","createdtime":null},{"startup_id":3,"startup_name":"start up three","description":"lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum.","createdtime":null}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"TotalItems":0,"startups":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>startup Forums</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupForums
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">startup_id(startup id),page_no(page number)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
							{"TotalItems":2,"Forums":[{"id":2,"forum_title":"forum two title","description":"lorem ipsum","forumCreatedBy":"Vijay Kumar","createdTime":null},{"id":3,"forum_title":"forum title","description":"forum description","forumCreatedBy":"Vijay Kumar","createdTime":"1899-11-22T14:21:26+0000"}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"TotalItems":0,"Forums":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>search Forums</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/searchForums
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">search_text(search text),page_no(page number),
															user_id(logged in user)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
							{"TotalItems":3,"Forums":[{"id":1,"forum_title":"forum one title key","description":"lorem ipsum","forumCreatedBy":"Vijay Kumar","createdTime":null},{"id":2,"forum_title":"forum two title","description":"lorem ipsum","forumCreatedBy":"Vijay Kumar","createdTime":null}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"TotalItems":0,"Forums":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>forum details with top 5 comments</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/forumDetail
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">forum_id(forum id)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
							{"Forums":{"forum_title":"forum one title key","forum_createdBy":"Vijay Kumar","forum_image":" ",
							"forum_description":"lorem ipsum","archivedClosedStatus":"1","forum_comments":[{"commenter_id":2,"commentedBy":"Vijay Kumar","CommentText":"good comment","commentedTime":"2016-05-04 05:35:23"},{"commenter_id":3,"commentedBy":"Neel Karn","CommentText":"good comment","commentedTime":"2016-05-04 05:35:23"},{"commenter_id":4,"commentedBy":"","CommentText":"good comment","commentedTime":"2016-05-04 05:35:23"},{"commenter_id":5,"commentedBy":"","CommentText":"good comment","commentedTime":"2016-05-04 05:35:23"}]},"code":200}
					</span></div>
                    </br>
                    <div>
					</br>NOte:-</b><span class="input-param">archivedClosedStatus[1-->archived,2-->closed,0-->neither archived nor closed]</span>
					<b>Error:-</b><span class="input-param">{"Forums":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>forum comments</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/forumcomments
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">forum_id(forum id)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
							{"TotalItems":5,"Comments":[[{"commenter_id":2,"commentedBy":"Vijay Kumar","CommentText":"good comment","userImage":"\/img\/default\/userdummy.png","commentedTime":"2016-05-04 05:35:23"},{"commenter_id":3,"commentedBy":"Neel Karn","CommentText":"good comment","userImage":"\/img\/default\/userdummy.png","commentedTime":"2016-05-04 05:35:23"},{"commenter_id":4,"commentedBy":"","CommentText":"good comment","userImage":"\/img\/default\/userdummy.png","commentedTime":"2016-05-04 05:35:23"},{"commenter_id":5,"commentedBy":"","CommentText":"good comment","userImage":"\/img\/default\/userdummy.png","commentedTime":"2016-05-04 05:35:23"},{"commenter_id":1,"commentedBy":"shivani pareek","CommentText":"hello comment","userImage":"\/img\/default\/userdummy.png","commentedTime":"2016-05-04 09:12:54"}]],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"TotalItems":0,"Comments":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Messages  archive List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/messagesArchiveList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(id of user who received messages),
					page_no(page number for pagination)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
									{"Messages":[{"id":1,"title":"this is subject","description":"lorem ipsum","sender":"Vijay Kumar","time":null},{"id":2,"title":"this is subject","description":"lorem ipsum","sender":"vijay hhhh","time":null}],"code":200}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"Messages":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>add Forum Comment</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addForumComment
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST[json]</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">
												{user_id(user id),forum_id(forum id),comment(comment)}
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
							{"code":200,"message":"commented submitted successfully"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":404,"message":"commented not submitted"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>My Forums List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/archivedForums
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(id of user who created forums),page_no(page number for pagination)
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
														{
							"Forums": [
								{
									"id": 1,
									"forum_title": "forum one title",
									"description": "lorem ipsum",
									"forumCreatedBy": "Vijay Kumar",
									"createdTime": null
								},
								{
									"id": 2,
									"forum_title": "forum two title",
									"description": "lorem ipsum",
									"forumCreatedBy": "Vijay Kumar",
									"createdTime": null
								},
								{
									"id": 3,
									"forum_title": "forum three title",
									"description": "lorem ipsum",
									"forumCreatedBy": "Vijay Kumar",
									"createdTime": null
								}
							],
							"code": 200
						}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"Forums":[],"code":404}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>Report Abuse</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/reportAbuse
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(id of user),forum_id(forum id),is_form_reported(true , false),
																		comment(comment),reported_users(array of objects containing user ids)
																			
																			
												 </span></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
						{"code":200,"message":"Report abuse successfully"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"code":200,"message":"Report abuse successfully"}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Commented Users</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/commentedUsers
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">forum_id(forum id)
												 </span></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										{
					"users": [
						{
							"user_id": 1,
							"user_image": "/img/default/userdummy.png",
							"user_name": "shivani pareek"
						},
						{
							"user_id": 2,
							"user_image": "/img/default/userdummy.png",
							"user_name": "Vijay Kumar"
						},
						{
							"user_id": 3,
							"user_image": "/img/default/userdummy.png",
							"user_name": "Neel Karn"
						},
						{
							"user_id": 4,
							"user_image": "/img/default/userdummy.png",
							"user_name": ""
						},
						{
							"user_id": 5,
							"user_image": "/img/default/userdummy.png",
							"user_name": ""
						}
					],
					"code": 200
				}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"users":[],"code":404}</span></div>
                    </div>';
					
					
					$ApiList[] = '<h3>Quickblox id of users</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/quickBloxId
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id)
												 </span></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										{
								"users": [
									{
										"user_id": "8",
										"quickbloxid": "1237686793",
										"username": "Vijay Kumar",
										"userimage": "/img/default/userdummy.png"
									},
									{
										"user_id": "11",
										"quickbloxid": "9897605",
										"username": "mark laq",
										"userimage": "/img/default/userdummy.png"
									},
									{
										"user_id": "9",
										"quickbloxid": "999999999",
										"username": "Vijay Kumar",
										"userimage": "/img/default/userdummy.png"
									},
									{
										"user_id": "10",
										"quickbloxid": "564875312",
										"username": "Mark Law",
										"userimage": "/img/default/userdummy.png"
									}
								],
								"code": 200
							}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"users":[],"code":404}</span></div>
                    </div>';
					 
					$ApiList[] = '<h3>Users notifications</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/UserNotifications
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),page_no(page number)
												 </span></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										{
											"TotalItems": 18,
											"notification": [
												{
													"id": 57,
													"tags": "Commit_Campaign",
													"values": "{\"campaign_id\":\"189\",\"campaign_name\":\"Campaign_Nikita\"}",
													"time": " ",
													"message": "Neha Mahajanhas commited on your campaign."
												},
												{
													"id": 56,
													"tags": "Report_Abuse_Forum",
													"values": "{\"forum_id\":\"79\",\"forum_name\":\"random\",\"own_forum\":\"false\"}",
													"time": " ",
													"message": "Nikita Misrahas report abused you."
												},
												{
													"id": 50,
													"tags": "TeamMember_rejected",
													"values": "[]",
													"time": " ",
													"message": "Neha Mahajanhas rejected your invitation for startup."
												},
												{
													"id": 48,
													"tags": "Comment_Forum",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajanhas commented on your forum."
												},
												{
													"id": 46,
													"tags": "Uncommit_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajanhas uncommited Campaign_Nikita."
												},
												{
													"id": 45,
													"tags": "Commit_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajanhas commited on your campaign."
												},
												{
													"id": 44,
													"tags": "UnFollow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan Unfollowed Campaign_Nikita."
												},
												{
													"id": 43,
													"tags": "Follow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan started following your campaign."
												},
												{
													"id": 42,
													"tags": "Uncommit_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajanhas uncommited Campaign_Nikita."
												},
												{
													"id": 41,
													"tags": "Commit_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajanhas commited on your campaign."
												},
												{
													"id": 40,
													"tags": "UnFollow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan Unfollowed Campaign_Nikita."
												},
												{
													"id": 39,
													"tags": "Follow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan started following your campaign."
												},
												{
													"id": 38,
													"tags": "UnFollow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan Unfollowed Campaign_Nikita."
												},
												{
													"id": 37,
													"tags": "Follow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan started following your campaign."
												},
												{
													"id": 36,
													"tags": "UnFollow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan Unfollowed Campaign_Nikita."
												},
												{
													"id": 35,
													"tags": "Follow_Campaign",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajan started following your campaign."
												},
												{
													"id": 34,
													"tags": "TeamMember_rejected",
													"values": " ",
													"time": " ",
													"message": "Neha Mahajanhas rejected your invitation for startup."
												},
												{
													"id": 33,
													"tags": "TeamMember_rejected",
													"values": " ",
													"time": "2016-06-05T20:54:27+0000",
													"message": "Neha Mahajanhas rejected your invitation for startup."
												}
											],
											"code": 200
										}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param">{"notification":[],"code":404}</span></div>
                    </div>';
					
					$ApiList[] = '<h3>Reject Commitment</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deleteCommitedUser
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b><span  class="input-param">user_id(user id),campaign_id(campaign id)
												 </span></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 {"code":"200","message":"successfully rejected"}
					</span></div>
                    </br>
                    <div><b>Error:-</b><span class="input-param"> {"code":"404","message":"can"t rejected"}</span></div>
                    </div>';
					

					$ApiList[] = '<h3>Startup Keywords</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupKeywords
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 {"startup_keywords":[{"id":1,"name":"Seed - Pre-Revenue"},{"id":2,"name":"Seed - Post-Revenue"},{"id":3,"name":"Series A"},{"id":4,"name":"Series B"},{"id":5,"name":"Growth"},{"id":6,"name":"Late Stage"}],"code":200}
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Submit Application Questions</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/submitApplicationQuestions
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b>startup_id,user_id</div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 {"code":200,"questions":{"above":{"Company Name":"","Your Name":"","Email":"","Phone Number":"","Company City":"","Company Country":"","Current Stage of Startup":"","Start Date of Startup":"","Is the startup incorporated?":"","How you participated in any incubator,\"accelerator\" or \"pre-accelerator\" program?":""},"cofounders":[{"Name":"","Age":"","University Degree":"","Subject":"","Facebook Twitter":"","Last Employed Job Title":"","How did you meet?":"","Have you worked together before?":"","How long have you known each other?":"","What is exceptional about your team?":"","What are the three most significant achievements of any member of your team?":""}],"below":{"Provide a brief description of your companys Products and Services":"","How do you make money?":"","Who are your target customers?":"","What do your target customers do today to meet their needs?":"","What is significantly different about your solution?":"","How do you know that customers want your solution?":"","Who are your competitors?":"","Have you worked together before?":"","What is your market entry strategy?":"","Why did you choose this opportunity?":"","What are the three most significant achievements of any member of your team?":""},"belowA":{"How many users do you have?":"","What is you monthly revenue?":"","What is your monthly growth rate?":""},"belowB":{"What prior investments have you received?":"","If you plan to raise funds, how much will you seek and what will you offer?":"","How will you become a huge company?":""},"belowC":{"Company Website":"","Company Video URL (hidden URL on Youtube is OK)":"","Video of Co Founders URL (hidden URL on Youtube is OK)":""},"belowD":{"Anything else you should declare (law suits, financial issues, performance problems, compliance issues)":""}}}
					</span></div>
                    </br>
                    <div>Error :{"code":404,"message":"No questions found."}</div>
                    </div>';


                    $ApiList[] = '<h3>Campaign Keywords</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/campaignKeywords
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 {"keywords":[{"id":1,"name":"Campaign - Keyword 1"},{"id":2,"name":"Campaign - Keyword 2"},{"id":3,"name":"Campaign - Keyword 3"},{"id":4,"name":"Campaign - Keyword 4"},{"id":5,"name":"Campaign - Keyword 5"},{"id":6,"name":"Campaign - Keyword 6"}],"code":200}
					</span></div>
                    </br>
                    <div></div>
                    </div>';


                    $ApiList[] = '<h3>Forum Keywords</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/forumKeywords
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 {"keywords":[{"id":1,"name":"Forum - Keyword 1"},{"id":2,"name":"Forum - Keyword 2"},{"id":3,"name":"Forum - Keyword 3"},{"id":4,"name":"Forum - Keyword 4"},{"id":5,"name":"Forum - Keyword 5"},{"id":6,"name":"Forum - Keyword 6"}],"code":200}
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Search Campaigns</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/searchCampaigns
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b>user_id</div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 {"code":404,"message":"No Campaigns found."}
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Startup Saved Workorders</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupSavedWorkorders
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Save Submit Workorder</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/saveSubmitWorkorder
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Approve Workorder Entrepreneur</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/approveWorkorderEntrepreneur
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Accept Workorder Entrepreneur</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/acceptWorkorderEntrepreneur
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Reject Workorder Entrepreneur</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/rejectWorkorderEntrepreneur
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Dynamic Roadmaps</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/dynamicRoadmaps
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Notifications Count</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/notificationsCount
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Update Notifications Count</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/updateNotificationsCount
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Startup Workorder Ratings</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/startupWorkorderRatings
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Entrepreneur Startup Workorders</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/entrepreneurStartupWorkorders
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Add Connection</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addConnection
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Accept Connection</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/acceptConnection
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Reject Connection</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/rejectConnection
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>My Connections</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/myConnections
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>My Messages</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/myMessages
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Search Connections</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/searchConnections
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Keyword Type List</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/keywordTypeList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Add Suggest Keywords</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addSuggestKeywords
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Suggest Keyword Lists</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/suggestKeywordLists
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Delete Suggest Keywords</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deleteSuggestKeywords
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">POST</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Company List</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/searchCompany
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b>user_id,search_text</div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>View Company</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/viewCompany
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b>user_id,company_id</div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Company Keyword List</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/companyKeywordList
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';


                    $ApiList[] = '<h3>Sponsors List (This does not include logged user added companies)</h3>
	                <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/sponsorsList?user_id=242
                    </br>
					<div><b>Request Type:-</b><span  class="input-param">GET</span></div>
					</br>
                    <div><b>Input Parameters:-</b>user_id</div>
                    </br>
					<div><b>output result:-</b><span class="input-param">
										 
					</span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Funds Manager List (This does not include logged user name)</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/fundsManagerLists?user_id=242
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">GET</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>user_id</div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Funds Keyword List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/fundsKeywordList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">GET</span></div>
                    </br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Funds Industry List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/fundIndustryLists
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">GET</span></div>
                    </br>
                    <div><b>Input Parameters:-</b></div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Funds Industry List (This does not include logged user added startups) </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/fundPortfolioList?user_id=242
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">GET</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>user_id</div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';



					$ApiList[] = '<h3>Add Funds </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addFunds
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>{
                        "user_id": "242",
                        "title": "Test fund",
                        "description": "description of fund",
                        "managers_id": "1,2",
                        "sponsors_id": "1,2",
                        "indusries_id": "1,2",
                        "portfolios_id": "1,2",
                        "keywords_id": "1,2",
                        "start_date": "01 Jan, 2017",
                        "end_date": "01 Jan, 2017",
                        "close_date": "01 Jan, 2017",
                        "document": "",
                        "image": "",
                        "audio": "",
                        "video": ""
                    }</div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';


                    $ApiList[] = '<h3>Edit Funds  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/editFunds
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>{
					    "user_id": "242",
					    "fund_id":"1",
					    "title": "Test fund",
					    "description": "description of fund",
					    "managers_id": "1,2",
					    "sponsors_id": "1,2",
					    "indusries_id": "1,2",
					    "portfolios_id": "1,2",
					    "keywords_id": "1,2",
					    "start_date": "01 Jan, 2017",
					    "end_date": "01 Jan, 2017",
					    "close_date": "01 Jan, 2017",
					    "document": "",
					    "image": "",
					    "audio": "",
					    "video": ""
					}</div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';


                    $ApiList[] = '<h3>Find Funds  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/findFunds
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>{
                        "user_id": "242",
                        "page_no":"1",
                        "search_text":"test 2"
                    }</div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>My Funds  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/myFunds
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "page_no":"1",
                        "search_text":"test 2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Fund Details </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/fundDetails
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "fund_id":"1"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Archive Fund  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/archiveFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "fund_id":"1"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Delete Fund </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deleteFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "fund_id":"1"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';


                    $ApiList[] = '<h3>Deactivate Fund </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deactivateFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "fund_id":"1"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Archive Fund List  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/archiveFundList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "page_no":"1",
                        "search_text":"test 2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Deactivate Fund List  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/deactivateFundList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "page_no":"1",
                        "search_text":"test 2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Activate Fund </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/activateFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "242",
                        "fund_id":"1"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';


                    $ApiList[] = '<h3>Dislike Fund </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/disLikeFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "dislike_by": "242",
                        "fund_id": "2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Like Fund </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/likeFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "like_by": "242",
                        "fund_id": "2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Fund Dislike list </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/fundDislikeList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "page_no": "1",
                        "fund_id": "2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Fund Like list </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/fundLikeList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "page_no": "1",
                        "fund_id": "1"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>unfollow Fund</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/unfollowFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "follow_by": "242",
                        "fund_id": "2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Follow Fund</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/followFund
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "follow_by": "242",
                        "fund_id": "2"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Beta Test Keyword List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/betaTestKeywordsList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">GET</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Beta Test Interest Keyword List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/betaInterestKeywordLists
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">GET</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Beta Test Target Market List</h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/betaTestTargetMarketsList
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">GET</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Add Beta Test </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/addBetaTest
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
					    "user_id": "288",
					    "title": "Test fund",
					    "description": "description of fund",
					    "beta_interest_keywords_id": "1,2",
					    "beta_test_keywords_id": "1,2",
					    "start_date": "Aug 3, 2017",
					    "end_date": "Aug 4, 2017",
					    "target_market": "fgsffg",
					    "document": "",
					    "image": "",
					    "audio": "",
					    "video": ""
					}
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';


					$ApiList[] = '<h3>Edit Beta Test  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/editBetaTest
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "288",
                        "beta_id":"4",
                        "title": "Test fund vj dff",
                        "description": "description of fund sadfsf dsf",
                        "beta_interest_keywords_id": "1,2,3",
                        "beta_test_keywords_id": "1,2,3",
                        "start_date": "Aug 1, 2017",
                        "end_date": "Aug 5, 2017",
                        "target_market": "1,2,3",
                        "document": "",
                        "image": "",
                        "audio": "",
                        "video": "",
                        "image_del": "",
                        "document_del": "",
                        "audio_del": "",
                        "video_del": ""
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';

                    $ApiList[] = '<h3>Beta Test Details  </h3>
                    <div class="url"><b>Url:-</b> http://'.$this->request->host().'/Api/betaTestDetails
                    </br>
                    <div><b>Request Type:-</b><span  class="input-param">POST</span></div>
                    </br>
                    <div><b>Input Parameters:-</b>
                    {
                        "user_id": "288",
                        "beta_id":"4"
                    }
                    </div>
                    </br>
                    <div><b>output result:-</b><span class="input-param">
                                         
                    </span></div>
                    </br>
                    <div></div>
                    </div>';




		$this->set('ApiList',$ApiList );
		$this->set('_serialize', ['ApiList']);
	}
 
	
}
