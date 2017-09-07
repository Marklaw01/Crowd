//
//  Title2CollectionViewCell.h
//  CrowdBootstrap
//
//  Created by Shikha Singla on 19/09/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roadmap.h"

@interface Title3CollectionViewCell : UICollectionViewCell{
    __weak IBOutlet UIButton *btnTitle;
    
    Roadmap *roadmap;
}

- (void)setData:(Roadmap *)roadmapObj;
- (IBAction)btnTitleClicked:(id)sender;


@end
