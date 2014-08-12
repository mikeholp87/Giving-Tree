//
//  Donate.m
//  Dude Where's My Car
//
//  Created by Mike Holp on 1/13/13.
//  Copyright (c) 2013 Flash Corp. All rights reserved.
//

#import "Donate.h"

#define STRIPE_TEST_PUBLISHABLE_KEY @"pk_test_MiARA4enREaL2qjwRiFTQTH8"
#define STRIPE_LIVE_PUBLISHABLE_KEY @"pk_live_n1dkBdja3COHYjl9ANPpWRC8"

@implementation Donate
@synthesize stripeBar, saveBtn, cancelBtn, moviePlayer, checkoutView, dimLayer, payButton, successView, environment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Donate";
}

- (void)viewWillAppear:(BOOL)animated
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15.0f, 0, 14.0f);
    UIImage *payBackgroundImage = [[UIImage imageNamed:@"button_secondary.png"] resizableImageWithCapInsets:insets];
    UIImage *payBackgroundImageHighlighted = [[UIImage imageNamed:@"button_secondary_selected.png"] resizableImageWithCapInsets:insets];
    [self.payButton setBackgroundImage:payBackgroundImage forState:UIControlStateNormal];
    [self.payButton setBackgroundImage:payBackgroundImageHighlighted forState:UIControlStateHighlighted];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.payButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dude Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)sendEmail:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;

        [controller setToRecipients:[NSArray arrayWithObject:@"mikeholp87@gmail.com"]];
        [controller setSubject:@"Request more info"];
            NSString *message = [NSString stringWithFormat:@"I would like to learn more about the car locator device!"];
        [controller setMessageBody:message isHTML:YES];
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Send" message:@"Device was unable to deliver your email at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if(result != MessageComposeResultSent){
        NSLog(@"Result: failed");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"Result: sent");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/****************************************************************************/
/*								Stripe Payment                              */
/****************************************************************************/

-(IBAction)useCreditCard:(id)sender
{
    self.navigationController.navigationBarHidden = YES;
    
    checkoutView = [[STPView alloc] initWithFrame:CGRectMake(15,50,290,55) andKey:STRIPE_TEST_PUBLISHABLE_KEY];
    checkoutView.delegate = self;
    
    dimLayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 700, 700)];
    dimLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    dimLayer.userInteractionEnabled = NO;
    [self.view addSubview:dimLayer];
    [self.view addSubview:checkoutView];
    
    stripeBar.hidden = NO;
    [self.view addSubview:stripeBar];
}

-(IBAction)saveCard:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [checkoutView createToken:^(STPToken *token, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(error)
            [self hasError:error];
        else
            [self hasToken:token];
    }];
}

-(IBAction)cancelCard:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    
    [dimLayer removeFromSuperview];
    [checkoutView removeFromSuperview];
    [stripeBar removeFromSuperview];
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    saveBtn.enabled = valid;
}

- (void)hasError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [message show];
}

- (void)hasToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://dwmcapp.com/API/stripe_api.php"]];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Payment Accepted!";
        hud.mode = MBProgressHUDModeText;
        
        if (error) {
            [self hasError:error];
        }else{
            NSLog(@"Success");
            [hud hide:YES afterDelay:1.0];
            [self cancelCard:self];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
