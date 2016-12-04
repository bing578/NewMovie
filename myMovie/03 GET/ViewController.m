//
//  ViewController.m
//  03 GET
//
//  Created by bing on 16/2/26.
//  Copyright © 2016年 bing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sendRequest2:(id)sender {
  
  NSURL* URL = [NSURL URLWithString:@"http://api.m.mtime.cn/Movie/HotLongComments.api?movieId=207872&pageIndex=1"];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
  request.HTTPMethod = @"GET";
  
  
  //自定义的session（会话）
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  /*
   defaultSessionConfiguration:默认的，数据缓存在沙盒中（documents/library/保存在temp）
   
   ephemeralSessionConfiguration:临时，数据保存在内存中
   backgroundSessionConfigurationWithIdentifier:后台，数据存储模式和默认的类型相同的
   
   identifier：作用表示后台的session，最好和bundle id相同
   */
  
  
   //创建session
  // (1)使用默认的session
//  NSURLSession *session =[NSURLSession sharedSession];
  
   // (2) 使用config自定义session
//  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
  
  // (3) 使用config自定义session，可以使用代理
   // 《1》使用代理
  
  /*
   sessionWithConfiguration:config
   delegate:NSURLSessionDataDelegate
   delegateQueue:代理方法执行的队列 （只是代理方法在主队列中执行）
   
   注意：session 发起网络请求，到接受网络请求，都是在后台线程中执行的
   */
  
  NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
  
  
  
  //创建task 《2》使用block
//  NSURLSessionDataTask *task = [session dataTaskWithRequest:<#(nonnull NSURLRequest *)#> completionHandler:<#^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>]
  
  
  //task
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
  
  //resume
  [task resume];
  

  
}

#pragma mark - URLSession Datadelegate

//didReceiveResponse
// 接受到响应

/**
 *  接受到响应
 *
 *  @param session           网络会话
 *  @param dataTask          任务
 *  @param response          响应头
 *  @param completionHandler 接收到响应之后，执行的block
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{

  NSLog(@"delegate's response is %@",response);//打印响应头
  
  
  /*
   NSURLSessionResponseCancel = 0, 取消这次请求
  NSURLSessionResponseAllow = 1,   允许继续接受响应体
  NSURLSessionResponseBecomeDownload  转换成下载任务
   */

  //允许继续接受响应体
  completionHandler(NSURLSessionResponseAllow);
  
}
//didReceiveData
//接收到数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{


  NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
  
  NSLog(@"json:%@",dic);
  
  

  
}





- (IBAction)sendRequest1:(id)sender {
  
  /* Configure session, choose between:
   * defaultSessionConfiguration
   * ephemeralSessionConfiguration
   * backgroundSessionConfigurationWithIdentifier:
   And set session-wide properties, such as: HTTPAdditionalHeaders,
   HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
   */
  NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
  
  /* Create session, and optionally set a NSURLSessionDelegate. */
  NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
  
//  NSURLSession *sesson = [NSURLSession sharedSession];
  
  /* Create the Request:
   My API (GET http://news-at.zhihu.com/api/3/news/latest)
   */
  
  NSURL* URL = [NSURL URLWithString:@"http://api.m.mtime.cn/Movie/HotLongComments.api?movieId=207872&pageIndex=1"];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
  request.HTTPMethod = @"GET";
  
  /* Start a new Task */
  NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      
      id json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      
    if (error == nil) {
      // Success
      NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
    }
    else {
      // Failure
      NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
    }
  }];
  [task resume];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
