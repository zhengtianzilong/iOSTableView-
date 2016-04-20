//
//  ZLTableViewController.m
//  tableView下拉图片变大
//
//  Created by appdev on 16/4/18.
//  Copyright © 2016年 appdev. All rights reserved.
//

#define navigationBarHeight 64.0f
#define imageHeight 200.0f
#define iconMargin 10
#define iconW 80
#define iconH 80

#import "ZLTableViewController.h"

@interface ZLTableViewController ()
@property (nonatomic, weak) UIImageView *topImageView;
@property (nonatomic, weak) UIImageView *iconView;

@end

@implementation ZLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableView的内边距空出一个imageView的位置
    self.tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    // 由于在上面已经将tableView整体往下移了(imageHeight:200)所以,为了让图片在最上面,应该y往上移动imageHeight
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -imageHeight, screenSize.width, imageHeight)];
    
    UIImage *oldImae= [UIImage imageNamed:@"1.jpg"];
    
    topImageView.image = [self originImage:oldImae scaleToSize:CGSizeMake(screenSize.width, imageHeight)];
    
    // 用这个属性主要是在拉的时候,能协调的拉伸
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:topImageView];
    self.topImageView = topImageView;
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(iconMargin, imageHeight - (iconMargin + iconH), iconW, iconH)];
    
    iconView.layer.cornerRadius = 7.5f;
    iconView.image = [UIImage imageNamed:@"5.jpg"];
    iconView.clipsToBounds = YES;
    iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.topImageView addSubview:iconView];
    self.iconView = iconView;


}

#pragma mark --- 给图片设置尺寸
- (UIImage *)originImage:(UIImage *)originImage scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return scaleImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
        
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    cell.textLabel.text = @"测试数据,往下拉看效果";
    
    return cell;
}

#pragma mark -- 拖动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 在没有拖动的时候,偏移量的y应该是-264(图片的高度加上导航栏)因为tableView是在图片下面的,从原来的0被图片占去之后,就变成264了
    NSLog(@"%f",scrollView.contentOffset.y);
    // 因为有导航栏的关系,所以要获得移动的距离需要加上导航栏的高度
    CGFloat y = scrollView.contentOffset.y + navigationBarHeight;
    
    // 往下拉的时候,偏移量是不断变大的,从原来的-200 到-201,
    if (y < -imageHeight) {
        
        CGRect frame = self.topImageView.frame;
        // 而图片,原来的y值是-200(为了顶格),当拉动产生偏移的时候,为了依然定格,则这个偏移的量就是图片的新的Y值,应为二者都是从-200开始的,往下拉了多少,我图片的
        // 的Y值就要往上回弹多少
        frame.origin.y = y;
        // 而图片的高度,高度原来是200,当拉动的时候偏移量之初就是-200(只是正负差别),所以随着偏移量的不断变大,那么图片也在变大
        // 所以图片的高度就是偏移量的正整数
        frame.size.height = -y;
        self.topImageView.frame = frame;
        
    }

}





@end
