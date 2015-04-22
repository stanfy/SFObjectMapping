//
//  ViewController.m
//  SFOObjcExample
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <SFObjectMapping/SFMappingCore.h>
#import "ViewController.h"
#import "SFBaseResponse.h"
#import "SFUserResponse.h"
#import "SFUser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self parseAllPossibleResponses];
}

- (void)parseAllPossibleResponses {

    // Base response
    SFBaseResponse *response = [self parseResponseOfClass:SFBaseResponse.class fromResouce:@"response.json"];
    NSAssert(response, @"Response should be parsed and correctly mapped");
    NSAssert(response.statusCode == 1, @"Response status code should be correclty mapped");
    NSAssert([response.message isEqualToString:@"OK"], @"Response mesage should be correclty mapped");
    NSLog(@"Successfully parsed %@ %@", NSStringFromClass(response.class), response);


    // User response
    response = [self parseResponseOfClass:SFUserResponse.class fromResouce:@"userresponse.json"];
    NSAssert(response, @"Response should be parsed and correctly mapped");
    NSAssert(response.statusCode == 2, @"Response status code should be correclty mapped");
    NSAssert([response.message isEqualToString:@"User is OK"], @"Response mesage should be correclty mapped");

    SFUserResponse * userResponse = (SFUserResponse *) response;
    NSAssert(userResponse.user, @"Response should have user");
    NSAssert(userResponse.user.gender == SFUserGenderMale, @"User should have correct gender");
    NSAssert(userResponse.user.userType == SFUserTypePremium, @"User should have correct type");
    NSAssert([userResponse.user.name isEqualToString:@"Artur"], @"User should have correct name");

    NSLog(@"Successfully parsed %@ %@", NSStringFromClass(response.class), response);


}

- (SFBaseResponse *)parseResponseOfClass:(Class)pClass fromResouce:(NSString *)resouce {
    // Get JSON
    NSURL *url = [[NSBundle mainBundle] URLForResource:[resouce stringByDeletingPathExtension] withExtension:[resouce pathExtension]];
    NSData * data = [NSData dataWithContentsOfURL:url options:0 error:nil];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    id result = [SFMappingCore instanceOfClass:pClass fromObject:json];
    
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
