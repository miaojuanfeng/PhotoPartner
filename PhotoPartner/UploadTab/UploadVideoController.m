//
//  UploadPhotoController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "AppDelegate.h"
#import "UploadVideoController.h"
#import <AFNetworking/AFNetworking.h>
#import <TZImagePickerController.h>
#import <TZImageManager.h>

//#define FileHashDefaultChunkSizeForReadingData 1024*8
#include <CommonCrypto/CommonDigest.h>

@interface UploadVideoController () <UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate, UIGestureRecognizerDelegate>
@property UITableView *tableView;
@property TZImagePickerController *imagePickerVc;

@property UITextView *textView;
@property UILabel *textCountLabel;
@property UIView *mediaView;
@property UIButton *addImageButton;

@property AppDelegate *appDelegate;
@end

@implementation UploadVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    
    self.navigationItem.title = NSLocalizedString(@"uploadVideoNavigationItemTitle", nil);
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"uploadSendRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickSubmitButton)];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    self.mediaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), IMAGE_VIEW_SIZE+2*GAP_HEIGHT)];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), 100)];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    [self.view addSubview:self.tableView];
    
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    self.imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    self.imagePickerVc.allowPickingImage = NO;
    self.imagePickerVc.allowPickingOriginalPhoto = NO;
   
    
    if( self.appDelegate.photos.count == 0 ){
         [self presentViewController:self.imagePickerVc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"推送设备";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if( section == 0 ){
        return 2;
    }else{
        return self.appDelegate.deviceList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return CGFLOAT_MIN;
    }else{
        return 12;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UploadMediaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.frame = CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.tableView), tableView.rowHeight);
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            self.tableView.rowHeight = GET_LAYOUT_HEIGHT(self.textView);
            self.textView.font = [UIFont fontWithName:@"AppleGothic" size:16.0];
            [cell.contentView addSubview:self.textView];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, GET_BOUNDS_WIDTH(cell));
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if( indexPath.row == 1 ){
            self.tableView.rowHeight = GET_LAYOUT_HEIGHT(self.mediaView);
            [self getMediaView:cell];
        }
    }else{
        self.tableView.rowHeight = 44;
        
        NSMutableDictionary *deviceItem = self.appDelegate.deviceList[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", [deviceItem objectForKey:@"device_name"], [deviceItem objectForKey:@"device_token"]];
        
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (void)getMediaView:(UITableViewCell *)cell {

    DO_CLEAR_MEDIA_VIEW;
    
    long imageTotal = self.appDelegate.photos.count;
    float imageViewSize = IMAGE_VIEW_SIZE;
    float x = GAP_WIDTH;
    float y = GAP_HEIGHT;
    for(int i=0;i<imageTotal;i++){
        if( i%IMAGE_PER_ROW == 0 ){
            x = GAP_WIDTH;
        }else{
            x += imageViewSize + GAP_HEIGHT;
        }
        if( i > 0 && i%IMAGE_PER_ROW == 0 ){
            y += imageViewSize + GAP_HEIGHT;
            self.mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(self.mediaView), 0, GET_LAYOUT_WIDTH(self.mediaView), y+imageViewSize+GAP_HEIGHT);
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
        //        imageView.backgroundColor = [UIColor orangeColor];
        imageView.image = self.appDelegate.photos[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)];
        singleTap.delegate = self;
        [imageView setTag:i];
        [imageView addGestureRecognizer:singleTap];
        [self.mediaView addSubview:imageView];
    }
    
    if( imageTotal%IMAGE_PER_ROW == 0 ){
        x = GAP_WIDTH;
    }else{
        x += imageViewSize + GAP_HEIGHT;
    }
    if( imageTotal > 0 && imageTotal%IMAGE_PER_ROW == 0 ){
        y += imageViewSize + GAP_HEIGHT;
        self.mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(self.mediaView), 0, GET_LAYOUT_WIDTH(self.mediaView), y+imageViewSize+GAP_HEIGHT);
    }
    /*
     *  移除旧的CGRect可点击区域
     */
    [self.addImageButton removeFromSuperview];
    if( self.appDelegate.photos.count == 0 ){
        self.addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
        [self.addImageButton setImage:[UIImage imageNamed:@"iv_upload"] forState:UIControlStateNormal];
        [self.addImageButton addTarget:self action:@selector(clickAddMediaButton) forControlEvents:UIControlEventTouchUpInside];
        self.addImageButton.layer.borderColor = BORDER_COLOR;
        self.addImageButton.layer.borderWidth = BORDER_WIDTH;
        [self.mediaView addSubview:self.addImageButton];
    }
    
    [cell.contentView addSubview:self.mediaView];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, GET_BOUNDS_WIDTH(cell));
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.rowHeight = GET_LAYOUT_HEIGHT(mediaView);
//    cell.frame = CGRectMake(GET_LAYOUT_OFFSET_X(cell), GET_LAYOUT_OFFSET_Y(cell), GET_LAYOUT_WIDTH(cell), GET_LAYOUT_HEIGHT(mediaView));
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"self.tableView.rowHeight: %f", GET_LAYOUT_HEIGHT(cell));
    NSLog(@"mediaView Height: %f", GET_LAYOUT_HEIGHT(self.mediaView));
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if( indexPath.section > 0 ){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if( indexPath.section == 1 ){
        NSString *device_id = [[self.appDelegate.deviceList objectAtIndex:indexPath.row] objectForKey:@"device_id"];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if( [self.appDelegate.deviceId containsObject:device_id] ){
            [self.appDelegate.deviceId removeObject:device_id];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            [self.appDelegate.deviceId addObject:device_id];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
//    self.focusImageIndex = self.fileDesc.count;
//    for (int i=0; i<photos.count; i++) {
//        [self.photos addObject:photos[i]];
//        [self.fileDesc addObject:@""];
//    }
//    NSLog(@"self.photos: %@", self.photos);
//    self.textView.text = [self.fileDesc objectAtIndex:self.focusImageIndex];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [self getMediaView:cell];
//    [self.tableView reloadData];
//}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    NSLog(@"%@", coverImage);
    self.appDelegate.focusImageIndex = self.appDelegate.fileDesc.count;
    [self.appDelegate.photos addObject:coverImage];
    [self.appDelegate.fileDesc addObject:@""];
    NSLog(@"self.photos: %@", self.appDelegate.photos);
    self.textView.text = [self.appDelegate.fileDesc objectAtIndex:self.appDelegate.focusImageIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self getMediaView:cell];
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"uploadProcessingRightBarButtonItemTitle", nil);
    
    [[TZImageManager manager] getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        NSString *PHImageFileSandboxExtensionTokenKey = [info objectForKey:@"PHImageFileSandboxExtensionTokenKey"];
        self.appDelegate.md5 =  [self.appDelegate md5:PHImageFileSandboxExtensionTokenKey];
        NSLog(@"视频md5计算完成,md5值为:%@", self.appDelegate.md5);
        
        [[TZImageManager manager] getVideoOutputPathWithAsset:asset success:^(NSString *outputPath){
            NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
            NSURL *videoUrl = [NSURL fileURLWithPath:outputPath];
            NSLog(@"videoUrl: %@", videoUrl);
            NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
            //        NSLog(@"***%@",videoData);
            NSLog(@"***%ld",videoData.length);
            
            if( ![self.appDelegate doDataToBlock:videoData] ){
                [self.appDelegate clearProperty];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [self getMediaView:cell];
                self.textView.text = @"";
                [self.tableView reloadData];
                HUD_TOAST_SHOW(NSLocalizedString(@"uploadVideoMaxSizeError", nil));
            }
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"uploadSendRightBarButtonItemTitle", nil);
            
            //        NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:videoUrl]]);
            //        NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[videoUrl path]]]);
            //
            //        NSURL *newVideoUrl ; //一般.mp4
            //        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
            //        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
            //        //    这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
            //        newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]];
            //        [self convertVideoQuailtyWithInputURL:videoUrl outputURL:newVideoUrl completeHandler:nil];
        } failure:^(NSString *errorMessage, NSError *error) {
            
        }];
    }];
}

- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}//此方法可以获取视频文件的时长。
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
    
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"Cancel");
}


/*
 *  要让AFHTTPSessionManager支持上传表单数组，需要修改AFNetworking/Serialization/AFURLRequestSerialization.m
 *  将
 *  [mutableQueryStringComponents addObjectsFromArray:AFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
 *  修改为
 *  [mutableQueryStringComponents addObjectsFromArray:AFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@", key], nestedValue)];
 */

- (void)clickSubmitButton {
    [self.view endEditing:YES];
    
    if( self.appDelegate.photos.count == 0 ){
        HUD_TOAST_SHOW(NSLocalizedString(@"uploadVideoEmptyError", nil));
        return;
    }
    if( self.appDelegate.deviceId.count == 0 ){
        HUD_TOAST_SHOW(NSLocalizedString(@"uploadDeviceEmptyError", nil));
        return;
    }
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*
     *  返回json格式数据时，如果没有下面代码，会提示上传失败，实际上已经成功。
     *  加上下面这句才会提示成功
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 30.0f;
    //发送post请求上传路径
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject响应体信息
     第六个参数:失败回调
     */
    NSLog(@"videos.count: %ld", self.appDelegate.videos.count);
    HUD_LOADING_SHOW(NSLocalizedString(@"uploadSendingRightBarButtonItemTitle", nil));
    NSString *totalBlock = [NSString stringWithFormat:@"%ld", self.appDelegate.videos.count];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"VID_%@_%d.mp4", [dateFormatter stringFromDate:date], arc4random() % 50001 + 100000];
    NSMutableArray *successBlock = [[NSMutableArray alloc] init];
    NSMutableArray *failedBlock = [[NSMutableArray alloc] init];
    if( self.appDelegate.fileDesc.count == 1 && [[self.appDelegate.fileDesc objectAtIndex:0] isEqualToString:@""] ){
        [self.appDelegate.fileDesc replaceObjectAtIndex:0 withObject:@" "];
    }
    for (int i=0; i< self.appDelegate.videos.count; i++) {
        NSString *fileBlock = [NSString stringWithFormat:@"%d", i+1];
        NSDictionary *parameters=@{
               @"user_id"       :   [self.appDelegate.userInfo objectForKey:@"user_id"],
               @"file_block"    :   fileBlock,
               @"total_block"   :   totalBlock,
               @"device_id"     :   [self.appDelegate.deviceId copy],
               @"file_MD5"      :   self.appDelegate.md5,
               @"file_desc"     :   [self.appDelegate.fileDesc copy]
        };
        [manager POST:BASE_URL(@"upload/video") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            /*
            *   使用formData拼接数据
            *   方法一:
            *   第一个参数:二进制数据 要上传的文件参数
            *   第二个参数:服务器规定的
            *   第三个参数:文件上传到服务器以什么名称保存
            */
            [formData appendPartWithFileData:self.appDelegate.videos[i] name:@"file" fileName:fileName mimeType:@"video/mp4"];

            NAV_UPLOAD_START;
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount / self.appDelegate.videos.count;
                NSNumber *number = [NSNumber numberWithFloat:progress];
                float total = 0.0f;
                if( self.appDelegate.completedUnitPercent.count > 0 ){
                    [self.appDelegate.completedUnitPercent replaceObjectAtIndex:i withObject:number];
                    for (NSNumber *num in self.appDelegate.completedUnitPercent) {
                        total += [num floatValue];
                    }
                    NSLog(@"self.completedUnitPercent: %f", total);
                }
                HUD_LOADING_PROGRESS(total);
            });
            NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"上传成功.%@",responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
            NSLog(@"results: %@", dic);
            
            NSDictionary *data = [dic objectForKey:@"data"];
            if( [[data objectForKey:@"complete"] intValue] ){
                
                NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                for(int i=0;i<self.appDelegate.photos.count;i++){
                    NSString *time = [dateFormatter stringFromDate:date];
                    NSString *device = @"";
                    for(int j=0;j<self.appDelegate.deviceId.count;j++){
                        NSString  *device_id = [self.appDelegate.deviceId objectAtIndex:j];
                        for(int k=0;k<self.appDelegate.deviceList.count;k++){
                            //                    NSLog(@"%@", [[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_id"] );
                            //                    NSLog(@"%@", device_id);
                            if( [[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_id"] == device_id ){
                                NSString *device_name = [[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_name"];
                                NSString *device_token = [[self.appDelegate.deviceList objectAtIndex:k] objectForKey:@"device_token"];
                                device = [NSString stringWithFormat:@"%@ %@(%@)", device, device_name, device_token];
                                break;
                            }
                        }
                    }
                    NSString *title = [NSString stringWithFormat:@"Send to%@", device];
                    NSString *desc = [self.appDelegate.fileDesc objectAtIndex:i];
                    UIImage *data = self.appDelegate.photos[i];
                    [self.appDelegate addMessageList:@"video" withTime:time withTitle:title withDesc:desc withData:data];
                }
                
                DO_FINISH_UPLOAD;
                NAV_UPLOAD_END;
                HUD_LOADING_HIDE;
                HUD_TOAST_SHOW(NSLocalizedString(@"uploadSendSuccess", nil));
            }else{
                [successBlock addObject:fileBlock];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"上传失败.%@",error);
            NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
            // 这里要记录下没有上传成功的块
            [failedBlock addObject:fileBlock];
            if( (successBlock.count + failedBlock.count) == self.appDelegate.videos.count ){
                NAV_UPLOAD_END;
                HUD_LOADING_HIDE;
                HUD_TOAST_SHOW(NSLocalizedString(@"uploadSendFailed", nil));
            }
        }];
    }
}

//- (AFHTTPSessionManager *)sharedManager {
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //最大请求并发任务数
//    manager.operationQueue.maxConcurrentOperationCount = 5;
//
//    // 请求格式
//    // AFHTTPRequestSerializer            二进制格式
//    // AFJSONRequestSerializer            JSON
//    // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
//
//    // 超时时间
//    manager.requestSerializer.timeoutInterval = 30.0f;
//    // 设置请求头
//    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
//    // 设置接收的Content-Type
//    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    // 返回格式
//    // AFHTTPResponseSerializer           二进制格式
//    // AFJSONResponseSerializer           JSON
//    // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
//    // AFXMLDocumentResponseSerializer (Mac OS X)
//    // AFPropertyListResponseSerializer   PList
//    // AFImageResponseSerializer          Image
//    // AFCompoundResponseSerializer       组合
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
////    //设置返回C的ontent-type
////    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
//
//    return manager;
//}

//CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
//                                      size_t chunkSizeForReadingData) {
//
//    // Declare needed variables
//    CFStringRef result = NULL;
//    CFReadStreamRef readStream = NULL;
//
//    // Get the file URL
//    CFURLRef fileURL =
//    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
//                                  (CFStringRef)filePath,
//                                  kCFURLPOSIXPathStyle,
//                                  (Boolean)false);
//    if (!fileURL) goto done;
//
//    // Create and open the read stream
//    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
//                                            (CFURLRef)fileURL);
//    if (!readStream) goto done;
//    bool didSucceed = (bool)CFReadStreamOpen(readStream);
//    if (!didSucceed) goto done;
//
//    // Initialize the hash object
//    CC_MD5_CTX hashObject;
//    CC_MD5_Init(&hashObject);
//
//    // Make sure chunkSizeForReadingData is valid
//    if (!chunkSizeForReadingData) {
//        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
//    }
//
//    // Feed the data to the hash object
//    bool hasMoreData = true;
//    while (hasMoreData) {
//        uint8_t buffer[chunkSizeForReadingData];
//        CFIndex readBytesCount = CFReadStreamRead(readStream,
//                                                  (UInt8 *)buffer,
//                                                  (CFIndex)sizeof(buffer));
//        if (readBytesCount == -1) break;
//        if (readBytesCount == 0) {
//            hasMoreData = false;
//            continue;
//        }
//        CC_MD5_Update(&hashObject,
//                      (const void *)buffer,
//                      (CC_LONG)readBytesCount);
//    }
//
//    // Check if the read operation succeeded
//    didSucceed = !hasMoreData;
//
//    // Compute the hash digest
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(digest, &hashObject);
//
//    // Abort if the read operation failed
//    if (!didSucceed) goto done;
//
//    // Compute the string result
//    char hash[2 * sizeof(digest) + 1];
//    for (size_t i = 0; i < sizeof(digest); ++i) {
//        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
//    }
//    result = CFStringCreateWithCString(kCFAllocatorDefault,
//                                       (const char *)hash,
//                                       kCFStringEncodingUTF8);
//
//done:
//
//    if (readStream) {
//        CFReadStreamClose(readStream);
//        CFRelease(readStream);
//    }
//    if (fileURL) {
//        CFRelease(fileURL);
//    }
//    return result;
//}

//- (NSString*)getFileMD5WithPath:(NSString*)path {
//    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
//}
//
//CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
//    // Declare needed variables
//    CFStringRef result = NULL;
//    CFReadStreamRef readStream = NULL;
//    // Get the file URL
//    CFURLRef fileURL =
//    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
//                                  (CFStringRef)filePath,
//                                  kCFURLPOSIXPathStyle,
//                                  (Boolean)false);
//    if (!fileURL) goto done;
//    // Create and open the read stream
//    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
//                                            (CFURLRef)fileURL);
//    if (!readStream) goto done;
//    bool didSucceed = (bool)CFReadStreamOpen(readStream);
//    if (!didSucceed) goto done;
//    // Initialize the hash object
//    CC_MD5_CTX hashObject;
//    CC_MD5_Init(&hashObject);
//    // Make sure chunkSizeForReadingData is valid
//    if (!chunkSizeForReadingData) {
//        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
//    }
//    // Feed the data to the hash object
//    bool hasMoreData = true;
//    while (hasMoreData) {
//        uint8_t buffer[chunkSizeForReadingData];
//        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
//        if (readBytesCount == -1) break;
//        if (readBytesCount == 0) {
//            hasMoreData = false;
//            continue;
//        }
//        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
//    }
//    // Check if the read operation succeeded
//    didSucceed = !hasMoreData;
//    // Compute the hash digest
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(digest, &hashObject);
//    // Abort if the read operation failed
//    if (!didSucceed) goto done;
//    // Compute the string result
//    char hash[2 * sizeof(digest) + 1];
//    for (size_t i = 0; i < sizeof(digest); ++i) {
//        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
//    }
//    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
//
//done:
//    if (readStream) {
//        CFReadStreamClose(readStream);
//        CFRelease(readStream);
//    }
//    if (fileURL) {
//        CFRelease(fileURL);
//    }
//    return result;
//}

- (void)clickAddMediaButton {
    if( self.appDelegate.photos.count > 0 ){
        return;
    }
    [self presentViewController:self.imagePickerVc animated:YES completion:nil];
}

- (void)clickImageView:(UIGestureRecognizer *) sender{
    [self setTextViewToFileDesc];
    self.appDelegate.focusImageIndex = sender.view.tag;
    self.textView.text = [self.appDelegate.fileDesc objectAtIndex:sender.view.tag];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setTextViewToFileDesc];
    NSLog(@"%@", self.appDelegate.fileDesc);
}

- (void)setTextViewToFileDesc {
    if( self.appDelegate.focusImageIndex > -1 ){
        NSLog(@"sds");
        [self.appDelegate.fileDesc replaceObjectAtIndex:self.appDelegate.focusImageIndex withObject:self.textView.text];
    }
}

- (void)didMoveToParentViewController:(UIViewController*)parent {
    if( !parent ){
        [self.appDelegate clearProperty];
    }
}

// 因为我在scrollView加了手势 点击tableView didSelectRowAtIndexPath不执行 导致手势冲突 可以用此方法解决
#pragma mark 解决手势冲突

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    } else {
        return YES;
    }
}

@end

