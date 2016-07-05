# WSNetworking



## Overview

**WSNetworking**, 根据AFNetworking3.0框架封装的，实现了GET、POST、PUT、DELETE、上传文件、下载文件、文件上传下载进度条等功能，同时支持IPv6。

#### 为什么使用它？
1. 简单快捷，只需要一句代码即可请求网络和文件处理
2. 只需要设置一个参数就能在界面上显示一个loading状态
3. block回调代码可读性更高
4. 快速上传下载文件，同时显示下载或上传进度条
5. 服务器请求接口单独用一个枚举来管理，方便查找和代码的阅读，提高开发效率
6. 支持IPv6

#### 公共方法
```objc
/**
 *  HTTP请求
 *
 *  @param taskID   服务器提供的接口，用一个枚举来管理
 *  @param param    传的参数
 *  @param method   GET,POST,DELETE,PUT方法
 *  @param success  请求完成
 *  @param failure  请求失败
 *  @param showView 界面上显示的网络加载进度状态(nil为不显示)
 */
 
+ (void)createRequest:(HTTP_COMMAND_LIST)taskID
            WithParam:(NSDictionary *)param
           withMethod:(HTTPRequestMethod)method
              success:(void(^)(id result))success
              failure:(void(^)(NSError *erro))failure
              showHUD:(UIView *)showView;

```
```objc
/**
 *  上传文件功能，如图片等
 *
 *  @param taskID             服务器提供的接口，用一个枚举来管理
 *  @param param              传的参数
 *  @param Exparam            文件流，将要上传的文件转成NSData中，然后一起传给服务器
 *  @param method             GET,POST,DELETE,PUT方法
 *  @param success            请求完成
 *  @param uploadFileProgress 请求图片的进度条，百分比
 *  @param failure            请求失败
 */ 
+ (void)createRequest:(HTTP_COMMAND_LIST)taskID
            WithParam:(NSDictionary*)param
          withExParam:(NSDictionary*)Exparam
           withMethod:(HTTPRequestMethod)method
              success:(void (^)(id result))success
              uploadFileProgress:(void(^)(NSProgress *uploadProgress))uploadFileProgress
              failure:(void (^)(NSError* erro))failure;
```
```objc
/**
 *  下载文件功能
 *
 *  @param URLString                 要下载文件的URL
 *  @param downloadFileProgress      下载的进度条，百分比
 *  @param setupFilePath             设置下载的路径
 *  @param downloadCompletionHandler 下载完成后（下载完成后可拿到存储的路径）
 */
+ (void)createDownloadFileWithURLString:(NSString *)URLString
             downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress
                    setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath
        downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler;
```
### 请求方式
#### GET请求

```objc
NSDictionary *parameter = @{@"type":@"top",
                                        @"key":@"3a7bda4e7369437ce9450026789a29c3"};
            [CKHttpCommunicate createRequest:HTTP_NEWS_TOP WithParam:parameter withMethod:GET success:^(id result) {
                
                if (result) {
                    NSLog(@"result:%@",result);
                }
            } failure:^(NSError *erro) {
                
            } showHUD:self.view];
```
#### POST请求

```objc
NSDictionary *parameter = @{@"type":@"top",
                                        @"key":@"3a7bda4e7369437ce9450026789a29c3"};
            [CKHttpCommunicate createRequest:HTTP_NEWS_TOP WithParam:parameter withMethod:POST success:^(id result) {
                
                if (result) {
                    NSLog(@"result:%@",result);
                }
            } failure:^(NSError *erro) {
                
            } showHUD:self.view];
```

### 文件处理
#### 上传文件
```objc
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
```
#### 下载文件

```objc
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

```

### 其他
#### 联系方式
QQ   : 491884687  
email: shlidty@163.com

#### 截图概述

![Mou icon](http://ww1.sinaimg.cn/mw690/63f96e20gw1f53wqayn2gg208u0g9nij.gif)
