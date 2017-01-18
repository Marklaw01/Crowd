//
//  HomeViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 06/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <iAd/iAd.h>
@class GADBannerView;

enum{
    HOW_IT_WORKS_SELECTED,
    INDEPENDENT_CONTRACTORS_SELECTED 
};

#define ENTREPRENEUR_DESCRIPTION @"You have a great idea for a startup but need a helping hand to accelerate your progress. Follow our lean startup process and our contractors will help you at each step - from formulating your idea to building an MVP to getting your first customer. Leverage our crowd of contractors to bootstrap your startup."

#define CONTRACTOR_DESCRIPTION @"Your experience includes expertise that can help a startup overcome a current or impending challenge. Or maybe you just want to help out. A little of your time can have a huge impact on the launch of a high impact startup. Help accelerate an entrepreneur through our lean startup process and empower them to bring their vision to life. Volunteer now to help an entrepreneur change the world."

#define HOW_IT_WORKS @"how_it_works"
#define INDEPENDENT_CONTRACTORS @"independent_contractor"

#define HOW_IT_WORKS_TITLE @"How It Works"
#define INDEPENDENT_CONTRACTORS_TITLE @"Independent Contractor Requirements"

// Info Screen
#define VISION_TITLE @"Our Vision"
#define MISSION_TITLE @"Our Mission"
#define VALUES_TITLE @"Our Values"

#define VISION_DESCRIPTION @"Our vision is the democratization of entrepreneurship by empowering any entrepreneur to transform their idea into initial revenues for close to $0."

#define MISSION_DESCRIPTION @"Our mission is to circumvent the cultural, geographic, knowledge and financial barriers to entrepreneurship by providing a lean startup roadmap and the resources required for an entrepreneur to bootstrap a startup from idea to initial revenues."

#define VALUES_DESCRIPTION @"1. Entrepreneurs: Innovate and execute then work hard to drive success.\n\n2. Startups: Create and respect intellectual property.\n\n3. Contractors: Do the right thing and do the thing right."

#define VISION_IMAGE @"Info_vision"
#define MISSION_IMAGE @"Info_mission"
#define VALUES_IMAGE @"Info_values"


enum INFO_TYPE{
    VISION_SELECTED,
    MISSION_SELECTED,
    VALUES_SELECTED
};


@interface HomeViewController : UIViewController <UIWebViewDelegate>{
    
   IBOutlet UIBarButtonItem *menuBarBtn;
   IBOutlet UIBarButtonItem *notificationsBarBtn;
   IBOutlet UIImageView *toggleBtnImg;
   IBOutlet UITextView *descTxtView;
   IBOutlet UIButton *independntContBtn;
   IBOutlet UIButton *leanStartupBtn;
   IBOutlet UIButton *howItWorkBtn;
   IBOutlet UIButton *expalinerVideoBtn;
   IBOutlet UIImageView *toggleImageView;
    
   IBOutlet UIView *popupView;
   IBOutlet UIWebView *popupWebView;
   IBOutlet UILabel *popupTitleLbl;
    
//   IBOutlet ADBannerView *bannerView;
   
   int selectedUserType ;
}
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

- (IBAction)btnLeadRoadMapClicked:(id)sender;


@end
