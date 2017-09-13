  //
//  ShoppingCartDetailViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 15/07/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartDetailViewController : UIViewController{
    IBOutlet UITextView    *contentTextView;
}
@property (strong,nonatomic) NSString *contentStr ;

@end
