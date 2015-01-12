//
//  ViewController.m
//  DivulgeASecret12306
//
//  Created by Liu.Yang on 12/26/14.
//  Copyright (c) 2014 Liu.Yang. All rights reserved.
//

#import "ViewController.h"

#import "AppMacro.h"
#import "UserInfo.h"
#import "DBControlHelper.h"
#import "UMA.h"

#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"

typedef NS_ENUM(NSInteger, ShelterType) {
    ShelterTypePhone,
    ShelterTypeEmail,
    ShelterTypeCardID,
};

@interface ViewController () <GADBannerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, strong) GADBannerView *adBannerView;

@end

@implementation ViewController

- (void)dealloc
{
    _adBannerView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    
    CGRect frame;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:30]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:RGB(100, 170, 225)];
    titleLabel.text = @"12306 密码泄露查询";
    
    frame.origin.x = (CGRectGetWidth(self.view.frame) - 300) / 2;
    frame.origin.y = 80.f;
    frame.size.width = 300.f;
    frame.size.height = 60.f;
    
    titleLabel.frame = frame;
    [self.view addSubview:titleLabel];
    
    
    _textFiled = [[UITextField alloc] init];
    _textFiled.backgroundColor = RGB(240, 240, 240);
    _textFiled.font = [UIFont systemFontOfSize:18];
    _textFiled.clearButtonMode = UITextFieldViewModeAlways;
    _textFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textFiled.keyboardAppearance = UIKeyboardAppearanceDefault;
    _textFiled.keyboardType = UIKeyboardTypeASCIICapable;
    _textFiled.returnKeyType = UIReturnKeyDone;
    _textFiled.textAlignment = NSTextAlignmentLeft;
    _textFiled.placeholder = @"请输入 手机号/身份证号/邮箱";
    _textFiled.textColor = RGB(102, 102, 102);
    _textFiled.layer.borderColor = RGB(100, 170, 225).CGColor;
    _textFiled.layer.borderWidth = 1.f;
    [_textFiled addTarget:self
                   action:@selector(textFieldDoneEditing)
         forControlEvents:UIControlEventEditingDidEndOnExit];
    UIView *paddingView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 10, 45}];
    paddingView.backgroundColor = [UIColor clearColor];
    _textFiled.leftView = paddingView;
    _textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    frame.origin.y = CGRectGetMaxY(titleLabel.frame) + 20.f;
    frame.size.height = 45.f;
    
    _textFiled.frame = frame;
    [self.view addSubview:_textFiled];
    
    _queryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _queryButton.backgroundColor = RGB(100, 170, 225);
    [_queryButton setTitle:@"立即查询"
                    forState:UIControlStateNormal];
    _queryButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_queryButton.titleLabel setTextColor:[UIColor whiteColor]];
    _queryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_queryButton addTarget:self
                       action:@selector(queryAction)
             forControlEvents:UIControlEventTouchUpInside];

    frame.origin.x = (CGRectGetWidth(self.view.frame) - 110.f) / 2;
    frame.origin.y = CGRectGetMaxY(_textFiled.frame) + 30.f;
    frame.size.width = 110.f;
    frame.size.height = 45.f;
    
    _queryButton.frame = frame;
    [self.view addSubview:_queryButton];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.textColor = RGB(153, 153, 153);
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.text = kPromptString;
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.numberOfLines = 0;
    promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    frame.origin.x = 10.f;
    frame.origin.y = CGRectGetMaxY(_queryButton.frame) + 60;
    frame.size.width = CGRectGetWidth(self.view.frame) - 20.f;
    frame.size.height = 90.f;
    promptLabel.frame = frame;
    [self.view addSubview:promptLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeKeyboard)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestAD];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LazyLoad
- (GADBannerView *)adBannerView
{
    if (!_adBannerView) {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        _adBannerView.adUnitID = BANNER_UNIT_ID;
        _adBannerView.rootViewController = self;
        _adBannerView.delegate = self;
    }
    return _adBannerView;
}

#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    /** 请求广告成功 */
    UMA_EVENT_WITH_LABEL(@"AdRequest", @"AdRequestSuccessful");
    if (![self.adBannerView isDescendantOfView:self.view]) {
        [self.view addSubview:self.adBannerView];
        self.adBannerView.frame = (CGRect){0,
            CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.adBannerView.bounds),
            self.adBannerView.frame.size};
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    /** 请求广告失败 */
    UMA_EVENT_WITH_LABEL(@"AdRequest", @"AdRequestFailed");
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    /** 广告点击 */
    UMA_EVENT(@"AdClicks");
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView
{
    /** 广告界面消失 */
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    /** 点击广告跳出应用程序 */
    UMA_EVENT(@"AdClicks");
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods
- (void)closeKeyboard
{
    if ([self.textFiled isFirstResponder]) {
        [self.textFiled resignFirstResponder];
    }
}

- (void)requestAD
{
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = @[GAD_SIMULATOR_ID, DEVICE_IDENTIFIER];
#endif
    [self.adBannerView loadRequest:request];
}

- (DBControlQueryType)getQueryType
{
    DBControlQueryType qt = DBControlQueryTypeUnknow;
    if (self.textFiled.text.length == 11) {
        qt = DBControlQueryTypePhone;
    } else if (self.textFiled.text.length == 18) {
        qt = DBControlQueryTypeCardId;
    } else if ([self validateEmail:self.textFiled.text]) {
        qt = DBControlQueryTypeEmail;
    }
    return qt;
}

- (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)queryAction
{
    NSString *title = nil;
    NSString *message = nil;
    if (self.textFiled.text.length != 0 && [self getQueryType] != DBControlQueryTypeUnknow) {
        DBControlQueryType queryType = [self getQueryType];
        UserInfo *userInfo = [[DBControlHelper sharedInstance] getUserInfoWithQueryString:self.textFiled.text
                                                                                queryType:queryType];
        if (userInfo.uid.length != 0) {
            title = @"您的帐号信息已泄露";
            NSString *shelterPhone = [self shelterInfoWithContent:userInfo.phoneNumber
                                                      shelterType:ShelterTypePhone];
            NSString *shelterEmail = [self shelterInfoWithContent:userInfo.uid
                                                      shelterType:ShelterTypeEmail];
            NSString *shelterCardID = [self shelterInfoWithContent:userInfo.cardid
                                                       shelterType:ShelterTypeCardID];
            message = [NSString stringWithFormat:kShowUserInfoString,userInfo.name, shelterPhone, shelterEmail, shelterCardID];
            [self.textFiled resignFirstResponder];
            UMA_EVENT_WITH_LABEL(@"QueryResults", @"Disclosure");
        } else {
            title = @"恭喜您 您的帐号没有泄露";
            message = @"您的帐号信息不在泄露数据中\n为了确保万无一失,建议您修改密码!";
            [self.textFiled resignFirstResponder];
            UMA_EVENT_WITH_LABEL(@"QueryResults", @"UnDisclosure");
        }
    } else {
        title = @"提示";
        message = @"请入正确的邮箱/手机号/身份证号\n重新查询";
        UMA_EVENT_WITH_LABEL(@"QueryResults", @"InputErrors");
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

- (NSString *)shelterInfoWithContent:(NSString *)content
                         shelterType:(ShelterType)shelterType
{
    NSString *shelterString = @"******";
    switch (shelterType) {
        case ShelterTypePhone:
        {
            shelterString = [content stringByReplacingCharactersInRange:NSMakeRange(3, 4)
                                                             withString:@"****"];
        }
            break;
            
        case ShelterTypeEmail:
        {
            shelterString = [content stringByReplacingCharactersInRange:NSMakeRange(0, 4)
                                                             withString:@"****"];
        }
            break;
            
        case ShelterTypeCardID:
        {
            shelterString = [content stringByReplacingCharactersInRange:NSMakeRange(8, 6)
                                                             withString:@"******"];
        }
            break;
            
        default:
            break;
    }
    
    return shelterString;
}

- (void)textFieldDoneEditing
{
    [self.textFiled resignFirstResponder];
    if (self.textFiled.text.length != 0) {
        [self queryAction];
    }
}

@end
