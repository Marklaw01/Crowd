//
//  InfoViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 28/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController{
    
    IBOutlet UILabel *titleLbl;
    IBOutlet UITextView *descriptionView;
    IBOutlet UIImageView *imgView;
}

@property (weak, nonatomic) NSString *infoTitle ;
@property (weak, nonatomic) NSString *infoDescription ;
@property (weak, nonatomic) NSString *infoImage ;

@end
