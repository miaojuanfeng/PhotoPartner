//
//  UploadPhotoController.m
//  PhotoPartner
//
//  Created by USER on 8/3/2018.
//  Copyright © 2018 MJF. All rights reserved.
//

#import "MacroDefine.h"
#import "UploadPhotoController.h"
#import <AFNetworking/AFNetworking.h>
#import <TZImagePickerController.h>

#define FileHashDefaultChunkSizeForReadingData 1024*8
#include <CommonCrypto/CommonDigest.h>

#define MAINLABEL_TAG 1
#define SECONDLABEL_TAG 2
#define PHOTO_TAG 3

#define IMAGE_PER_ROW 5
#define IMAGE_VIEW_SIZE (GET_LAYOUT_WIDTH(self.view)-GAP_WIDTH*(IMAGE_PER_ROW+1))/IMAGE_PER_ROW

@interface UploadPhotoController () <UITableViewDataSource, UITableViewDelegate, TZImagePickerControllerDelegate>
@property UITableView *tableView;

@property NSMutableArray *deviceId;
@property NSMutableArray *fileDesc;
@property NSMutableArray<UIImage *> *photos;

@property UITextView *textView;
@property UIView *mediaView;
@end

@implementation UploadPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    COMMON_MACRO;
    
    self.navigationItem.title = NSLocalizedString(@"uploadPhotoNavigationItemTitle", nil);
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"uploadPhotoRightBarButtonItemTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickSubmitButton)];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    self.deviceId = [[NSMutableArray alloc] init];
    self.fileDesc = [[NSMutableArray alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    
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
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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
        return 20;
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
            self.tableView.rowHeight = GET_LAYOUT_HEIGHT(self.textView);
            NSLog(@"%f",GET_LAYOUT_HEIGHT(self.textView));
//            self.textView.backgroundColor = [UIColor redColor];
            self.textView.font = [UIFont fontWithName:@"AppleGothic" size:16.0];
            
            [cell.contentView addSubview:self.textView];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, GET_BOUNDS_WIDTH(cell));
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else if( indexPath.row == 1 ){
//            mediaView.backgroundColor = [UIColor blueColor];
//            int imagePerRow = 5;
//            int imageTotal = 10;
//            float imageViewSize = (GET_LAYOUT_WIDTH(mediaView)-GAP_WIDTH*(imagePerRow+1))/imagePerRow;
//            float x = GAP_WIDTH;
//            float y = GAP_HEIGHT;
//            for(int i=0;i<imageTotal;i++){
//                if( i%imagePerRow == 0 ){
//                    x = GAP_WIDTH;
//                }else{
//                    x += imageViewSize + GAP_HEIGHT;
//                }
//                if( i > 0 && i%imagePerRow == 0 ){
//                    y += imageViewSize + GAP_HEIGHT;
//                    mediaView.frame = CGRectMake(GET_LAYOUT_OFFSET_X(mediaView), 0, GET_LAYOUT_WIDTH(mediaView), y+imageViewSize+GAP_HEIGHT);
//                }
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
//        //        imageView.backgroundColor = [UIColor orangeColor];
//                imageView.image = [UIImage imageNamed:@"image"];
//                [mediaView addSubview:imageView];
//            }
            NSLog(@"mediaView HEight: %f", GET_LAYOUT_HEIGHT(self.mediaView));
//            CGRect rect = cell.frame;
//            rect.size.height = [self getMediaView:cell];
//            cell.frame = rect;
//            NSLog(@"%f", GET_LAYOUT_HEIGHT(cell));
            self.tableView.rowHeight = GET_LAYOUT_HEIGHT(self.mediaView);
            [self getMediaView:cell];
//            cell.backgroundColor = [UIColor blueColor];
        }
    }else{
        self.tableView.rowHeight = 44;
        cell.textLabel.text = @"设备编号（axz1122334）";
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (void)getMediaView:(UITableViewCell *)cell {
//    mediaView.backgroundColor = [UIColor blueColor];
    long imageTotal = self.photos.count;
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
        imageView.image = self.photos[i];
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
    UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, imageViewSize, imageViewSize)];
    [addImageButton setImage:[UIImage imageNamed:@"iv_upload"] forState:UIControlStateNormal];
    [addImageButton addTarget:self action:@selector(clickAddMediaButton) forControlEvents:UIControlEventTouchUpInside];
    addImageButton.layer.borderColor = BORDER_COLOR;
    addImageButton.layer.borderWidth = BORDER_WIDTH;
    [self.mediaView addSubview:addImageButton];
    
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
    //    VideoDetailController *videoDetailController = [[VideoDetailController alloc] init];
    //    [self.navigationController pushViewController:videoDetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSLog(@"%@", photos);
//    for (int i=0; i<photos.count; i++) {
//        [self.photos addObject:photos[i]];
//    }
    [self.photos addObjectsFromArray:photos];
    NSLog(@"self.photos: %@", self.photos);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self getMediaView:cell];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    NSLog(@"%@", coverImage);
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
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //发送post请求上传路径
    /*
     第一个参数:请求路径
     第二个参数:字典(非文件参数)
     第三个参数:constructingBodyWithBlock 处理要上传的文件数据
     第四个参数:进度回调
     第五个参数:成功回调 responseObject响应体信息
     第六个参数:失败回调
     */
    NSLog(@"%ld", self.photos.count);
    NSMutableArray<NSData *> *file = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.photos.count; i++) {
        [self.deviceId addObject:@1];
        [self.fileDesc addObject:@2];
        [file addObject:UIImagePNGRepresentation(self.photos[i])];
    }
    NSDictionary *parameters=@{@"user_id":@"1",@"device_id":[self.deviceId copy],@"file_desc":[self.fileDesc copy]};
    [manager POST:@"https://well.bsimb.cn/upload/image" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        UIImage *image = [UIImage imageNamed:@"image"];
//        NSData *imageData = UIImagePNGRepresentation(image);
//
//        UIImage *image2 = [UIImage imageNamed:@"iv_upload"];
//        NSData *imageData2 = UIImagePNGRepresentation(image2);
        
        //使用formData拼接数据
        /* 方法一:
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:文件上传到服务器以什么名称保存
         */
        for (int i=0; i< file.count; i++) {
            [formData appendPartWithFileData:file[i] name:@"file" fileName:[NSString stringWithFormat:@"MichaelMiao%d.png", i] mimeType:@"image/png"];
        }
//        [formData appendPartWithFileData:imageData name:@"file" fileName:@"xx1.png" mimeType:@"image/png"];
//        [formData appendPartWithFileData:imageData2 name:@"file" fileName:@"xx2.png" mimeType:@"image/png"];
        
//        //方法二:
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@""] name:@"file" fileName:@"xxx.png" mimeType:@"image/png" error:nil];
//
//        //方法三:
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@""] name:@"file" error:nil];
        
    }
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
             NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSLog(@"上传成功.%@",responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"上传失败.%@",error);
              NSLog(@"%@",[[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
          }];
    
    [self.navigationController popViewControllerAnimated:YES];
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




- (NSString*)getFileMD5WithPath:(NSString*)path {
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

- (void)clickAddMediaButton {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

@end

