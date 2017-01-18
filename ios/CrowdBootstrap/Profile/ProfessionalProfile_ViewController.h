//
//  ProfessionalProfile_ViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 19/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTagsControl.h"

enum{
    PROFILE_PROF_EXPERIENCE_SELECTED,
    PROFILE_PROF_CONTRACTOR_TYPE_SELECTED
};

#define kProfTextFieldCellIdentifier        @"TextFieldCell"
#define kProfExperienceCellIdentifier       @"ExperienceCell"
#define kProfKeywordsCellIdentifer          @"KeywordsCell"
#define kProfAccreditedCellIdentifier       @"AccreditedCell"
#define kProfDescriptionCellIdentifier      @"DescriptionCell"
#define kProfSubmitCellIdentifier           @"SubmitCell"


#define kContProfExperienceCellIndex        0
#define kContProfKeywordsCellIndex          1
#define kContProfQualificationsCellIndex    2
#define kContProfCertificationsCellIndex    3
#define kContProfSkillsCellIndex            4
#define kContProfStartupStageCellIndex      6
#define kContProfContractorTypeCellIndex    7
#define kContProfAccreditedCellIndex        8

#define kEntProfDescriptionCellIndex        2
#define kEntProfKeywordsCellIndex           3
#define kEntProfQualificationsCellIndex     4
#define kEntProfSkillsCellIndex             5


@interface ProfessionalProfile_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TLTagsControlDelegate,UIPickerViewDelegate>{
    
    IBOutlet UITableView                    *tblView ;
    IBOutlet UIView                         *pickerViewContainer;
    IBOutlet UIPickerView                   *pickerView;
    
    
    NSMutableArray                          *profProfileArray ;
    NSMutableArray                          *selectedKeywordsArray ;
    NSMutableArray                          *selectedQualificationsArray ;
    NSMutableArray                          *selectedCertificationsArray ;
    NSMutableArray                          *selectedSkillsArray ;
    NSMutableArray                          *selectedPreferredStartupArray ;
    NSArray                                 *experienceArray ;
    NSArray                                 *contractorTypeArray ;
    NSArray                                 *keywordsArray ;
    NSArray                                 *startupsArray ;
    NSArray                                 *qualificationsArray ;
    NSArray                                 *certificationsArray ;
    NSArray                                 *skillsArray ;
    NSMutableDictionary                     *profileDict ;
    
    NSString                                *selectedExperienceID ;
    NSString                                *selectedContractorTypeID ;
    int                                     selectedPickerViewType ;
    int                                     selectedTextViewIndex ;
    
}

@property UIView *selectedItem;

@end
