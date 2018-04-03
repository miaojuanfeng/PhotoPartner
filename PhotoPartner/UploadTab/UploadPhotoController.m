//
//  UploadPhotoController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <TZImagePickerController.h>
#import <MBProgressHUD.h>
#import "MacroDefine.h"
#import "AppDelegate.h"
#import "UploadPhotoController.h"

@interface UploadPhotoController () <UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate, UIGestureRecognizerDelegate>
@property UITableView *tableView;
@property TZImagePickerController *imagePickerVc;

@property AppDelegate *appDelegate;

@property UITextView *textView;
@property UIView *mediaView;
@property UIButton *addImageButton;
@end

@implementation UploadPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;

    self.navigationItem.title = NSLocalizedString(@"uploadPhotoNavigationItemTitle", nil);
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
//    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 44, GET_LAYOUT_WIDTH(self.view), 1)];
//    self.progressView.trackTintColor = [UIColor blackColor];
//    self.progressView.progressTintColor = [UIColor yellowColor];
//    [self.navigationController.navigationBar addSubview:self.progressView];

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
    self.imagePickerVc.allowPickingVideo = NO;
    self.imagePickerVc.allowPickingOriginalPhoto = NO;
    self.imagePickerVc.allowTakePicture = NO;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), 100)];

    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"uploadSendRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickSubmitButton)];
    self.navigationItem.rightBarButtonItem = submitButton;
    self.mediaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GET_LAYOUT_WIDTH(self.view), IMAGE_VIEW_SIZE+PHOTO_NUM_HEIGHT+GAP_HEIGHT+2*GAP_HEIGHT)];
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
//        return tableView.sectionHeaderHeight;
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
            self.tableView.rowHeight = GET_LAYOUT_HEIGHT(self.textView)+PHOTO_NUM_HEIGHT;
            self.textView.font = [UIFont fontWithName:@"AppleGothic" size:16.0];
            [cell.contentView addSubview:self.textView];
            
            UILabel *textCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GET_LAYOUT_OFFSET_Y(self.textView)+GET_LAYOUT_HEIGHT(self.textView), GET_LAYOUT_WIDTH(self.textView), PHOTO_NUM_HEIGHT)];
            textCountLabel.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:textCountLabel];
            
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
    self.addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
    [self.addImageButton setImage:[UIImage imageNamed:@"iv_upload"] forState:UIControlStateNormal];
    [self.addImageButton addTarget:self action:@selector(clickAddMediaButton) forControlEvents:UIControlEventTouchUpInside];
    self.addImageButton.layer.borderColor = BORDER_COLOR;
    self.addImageButton.layer.borderWidth = BORDER_WIDTH;
    [self.mediaView addSubview:self.addImageButton];
    
    UILabel *photoNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(GET_LAYOUT_OFFSET_X(self.mediaView), GET_LAYOUT_OFFSET_Y(self.mediaView)+GET_LAYOUT_HEIGHT(self.mediaView), GET_LAYOUT_WIDTH(self.mediaView), PHOTO_NUM_HEIGHT)];
    photoNumLabel.text = [NSString stringWithFormat:@"%ld/9", self.appDelegate.photos.count];
    photoNumLabel.textColor = [UIColor lightGrayColor];
    photoNumLabel.font = [UIFont systemFontOfSize:14.0f];
    photoNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.mediaView addSubview:photoNumLabel];
//    photoNumLabel.backgroundColor = [UIColor blueColor];
    self.mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(self.mediaView), 0, GET_LAYOUT_WIDTH(self.mediaView), GET_LAYOUT_HEIGHT(self.mediaView)+PHOTO_NUM_HEIGHT+GAP_HEIGHT);
    
    [cell.contentView addSubview:self.mediaView];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, GET_BOUNDS_WIDTH(cell));
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSString *device_id = [[self.appDelegate.deviceList objectAtIndex:indexPath.row] objectForKey:@"device_id"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if( [self.appDelegate.deviceId containsObject:device_id] ){
        [self.appDelegate.deviceId removeObject:device_id];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        [self.appDelegate.deviceId addObject:device_id];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    [self.appDelegate clearPickerProperty];
    
    self.appDelegate.focusImageIndex = self.appDelegate.fileDesc.count;
    for (int i=0; i<photos.count; i++) {
        [self.appDelegate.photos addObject:photos[i]];
        [self.appDelegate.isTakePhoto addObject:[NSString stringWithFormat:@"%d", false]];
        [self.appDelegate.fileDesc addObject:@""];
    }
    self.textView.text = [self.appDelegate.fileDesc objectAtIndex:self.appDelegate.focusImageIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self getMediaView:cell];
    [self.tableView reloadData];
}

//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
//    NSLog(@"%@", coverImage);
//}

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
        HUD_TOAST_SHOW(NSLocalizedString(@"uploadPhotoEmptyError", nil));
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
    manager.requestSerializer.timeoutInterval = 30.0f;
    //发送post请求上传路径
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject响应体信息
     第六个参数:失败回调
     */
    NSLog(@"%ld", self.appDelegate.photos.count);
    HUD_LOADING_SHOW(NSLocalizedString(@"uploadSendingRightBarButtonItemTitle", nil));
    if( self.appDelegate.fileDesc.count == 1 && [[self.appDelegate.fileDesc objectAtIndex:0] isEqualToString:@""] ){
        [self.appDelegate.fileDesc replaceObjectAtIndex:0 withObject:@" "];
    }
    NSDictionary *parameters=@{@"user_id":[self.appDelegate.userInfo objectForKey:@"user_id"],@"device_id":[self.appDelegate.deviceId copy],@"file_desc":[self.appDelegate.fileDesc copy]};
    [manager POST:BASE_URL(@"upload/image") parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        /*
        *   使用formData拼接数据
        *   方法一:
        *   第一个参数:二进制数据 要上传的文件参数
        *   第二个参数:服务器规定的
        *   第三个参数:文件上传到服务器以什么名称保存
        */
        for (int i=0; i< self.appDelegate.photos.count; i++) {
            int imageWidth = 0;
            int imageHeight = 0;
            if( self.appDelegate.photos[i].size.width >= self.appDelegate.photos[i].size.height ){
                imageWidth = 750;
                imageHeight = 750 / self.appDelegate.photos[i].size.width * self.appDelegate.photos[i].size.height;
            }else{
                imageWidth = 750 / self.appDelegate.photos[i].size.height * self.appDelegate.photos[i].size.width;
                imageHeight = 750;
            }
            CGSize imageSize = CGSizeMake(imageWidth, imageHeight);
            NSData *file = [self compressQualityWithMaxLength:PHOTO_MAX_SIZE withSourceImage:[self imageByScalingAndCroppingForSize:imageSize withSourceImage:self.appDelegate.photos[i]]];
            NSString *fileExt = [self typeForImageData:file];
            if( fileExt == nil ){
                fileExt = @"jpeg";
            }
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
            NSString *fileName = [NSString stringWithFormat:@"IMG_%@_%d", [dateFormatter stringFromDate:date], arc4random() % 50001 + 100000];
            [formData appendPartWithFileData:file name:@"file" fileName:[NSString stringWithFormat:@"%@.%@", fileName, fileExt] mimeType:[NSString stringWithFormat:@"image/%@", fileExt]];
        }
        NAV_UPLOAD_START;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            
            HUD_LOADING_PROGRESS(progress);
        });
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功.%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSLog(@"results: %@", dic);
        
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
            [self.appDelegate addMessageList:@"image" withTime:time withTitle:title withDesc:desc withData:data];
        }
        
        DO_FINISH_UPLOAD;
        NAV_UPLOAD_END;
        HUD_LOADING_HIDE;
        HUD_TOAST_SHOW(NSLocalizedString(@"uploadSendSuccess", nil));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败.%@",error);
        NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);

        NAV_UPLOAD_END;
        HUD_LOADING_HIDE;
        HUD_TOAST_SHOW(NSLocalizedString(@"uploadSendFailed", nil));
    }];
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

- (void)clickAddMediaButton {
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
}

- (void)setTextViewToFileDesc {
    if( self.appDelegate.focusImageIndex > -1 ){
        [self.appDelegate.fileDesc replaceObjectAtIndex:self.appDelegate.focusImageIndex withObject:self.textView.text];
    }
}

- (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
    }
    return nil;
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

/**
 *  图片压缩到指定大小
 *  @param targetSize  目标图片的大小
 *  @param sourceImage 源图片
 *  @return 目标图片
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength withSourceImage:(UIImage *)sourceImage{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(sourceImage, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(sourceImage, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

//- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength withSourceImage:(UIImage *)sourceImage{
//    CGFloat compression = 1;
//    NSData *data = UIImageJPEGRepresentation(sourceImage, compression);
//    while (data.length > maxLength && compression > 0) {
//        compression -= 0.02;
//        data = UIImageJPEGRepresentation(sourceImage, compression); // When compression less than a value, this code dose not work
//    }
//    return data;
//}

@end

