//
//  ViewController.m
//  NetworkSample
//
//  Created by shlity on 16/6/21.
//  Copyright © 2016年 Moresing Inc. All rights reserved.
//

#import "ViewController.h"
#import "CKHttpCommunicate.h"
#import "MBProgressHUD.h"

static void *ProgressObserverContext = &ProgressObserverContext;

@interface ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) MBProgressHUD  *HUD;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *btnTitle = @[@"GetMethod",@"PostMethod",@"upload file",@"download file"];
    for (int i = 0; i < btnTitle.count; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 120 + (70 * i), self.view.frame.size.width - 20, 44)];
        [button setTitle:btnTitle[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:button];
    }
}

- (void)onClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            NSDictionary *parameter = @{@"type":@"top",
                                        @"key":@"3a7bda4e7369437ce9450026789a29c3"};
            [CKHttpCommunicate createRequest:HTTP_NEWS_TOP WithParam:parameter withMethod:GET success:^(id result) {
                
                if (result) {
                    NSLog(@"result:%@",result);
                }
            } failure:^(NSError *erro) {
                
            } showHUD:self.view];
        }
            break;
        case 1:
        {
            NSDictionary *parameter = @{@"type":@"top",
                                        @"key":@"3a7bda4e7369437ce9450026789a29c3"};
            [CKHttpCommunicate createRequest:HTTP_NEWS_TOP WithParam:parameter withMethod:POST success:^(id result) {
                
                if (result) {
                    NSLog(@"result:%@",result);
                }
            } failure:^(NSError *erro) {
                
            } showHUD:self.view];
        }
            break;
        case 2:
        {
            UIActionSheet *actionSheet;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择", @"立即拍照上传", nil];
            }
            else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
            }
            
            actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
            [actionSheet showInView:self.view];
        }
            break;
        case 3:
        {
            [self hudTipWillShow:YES];
            [CKHttpCommunicate createDownloadFileWithURLString:@"https://codeload.github.com/Ahmed-Ali/JSONExport/zip/master" downloadFileProgress:^(NSProgress *downloadProgress) {
                
                if (self.HUD) {
                    
                    self.HUD.progress = downloadProgress.fractionCompleted;
                    
                    _HUD.labelText = [NSString stringWithFormat:@"%2.f%%",downloadProgress.fractionCompleted*100];
                    
                }
                
            } setupFilePath:^NSURL *(NSURLResponse *response) {
                
                NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                
                return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
                
            } downloadCompletionHandler:^(NSURL *filePath, NSError *error) {
                
                [[[UIAlertView alloc]initWithTitle:@"下载路径" message: [NSString stringWithFormat:@"%@",filePath] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
                
                [self hudTipWillShow:NO];
            }];
            
        }
            break;
        default:
            break;
    }
}

/*upload images*/
- (void)updateImageToServer:(NSData *)data
{
    
    NSMutableDictionary *Exparams = [[NSMutableDictionary alloc]init];
    
    [Exparams addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:data,@"imageName", nil]];
    
    
    [self hudTipWillShow:YES];
    
    [CKHttpCommunicate createRequest:HTTP_UPDATE_AVATA WithParam:nil withExParam:Exparams withMethod:POST success:^(id result) {
        
        [self hudTipWillShow:NO];
        
    } uploadFileProgress:^(NSProgress *uploadProgress) {
        
        self.HUD.progress = uploadProgress.fractionCompleted;
        
        _HUD.labelText = [NSString stringWithFormat:@"%2.f%%",uploadProgress.fractionCompleted*100];
        
    } failure:^(NSError *erro) {
        
        [self hudTipWillShow:NO];
        
    }];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (buttonIndex == 0) { //相册
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }else if (buttonIndex == 1){  //照相机
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }else{
        if (buttonIndex == 0) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

#pragma mark -- init MBProgressHUD
- (void)hudTipWillShow:(BOOL)willShow{
    if (willShow) {
        [self resignFirstResponder];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!_HUD) {
            _HUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            _HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            _HUD.removeFromSuperViewOnHide = YES;
        }else{
            _HUD.progress = 0;
            _HUD.labelText = @"0%";
            [keyWindow addSubview:_HUD];
            [_HUD show:YES];
        }
    }else{
        [_HUD hide:YES];
    }
}

#pragma mark -- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    [self updateImageToServer:imageData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
