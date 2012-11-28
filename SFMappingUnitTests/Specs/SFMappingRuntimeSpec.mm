#import "SFMappingRuntime.h"

#import "TestProperty.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(SFMappingRuntimeSpec)

describe(@"SFMappingRuntime", ^{
   
   describe(@"should parse property correct", ^{
      
      it(@"for Class", ^{
         NSString *propertyType = [SFMappingRuntime typeForProperty:@"stringProperty"
                                                            ofClass:[TestProperty class]];
         [propertyType isEqualToString:@"NSString"] should be_truthy;
      });
      
      context(@"for simple type", ^{
         
         it(@"integer", ^{
            NSString *propertyType = [SFMappingRuntime typeForProperty:@"intProperty"
                                                               ofClass:[TestProperty class]];
            [propertyType isEqualToString:@"NSNumber"] should be_truthy;
         });
         
         it(@"real", ^{
            NSString *propertyType = [SFMappingRuntime typeForProperty:@"floatProperty"
                                                               ofClass:[TestProperty class]];
            [propertyType isEqualToString:@"NSNumber"] should be_truthy;
         });
         
         it(@"boolean", ^{
            NSString *propertyType = [SFMappingRuntime typeForProperty:@"boolProperty"
                                                               ofClass:[TestProperty class]];
            [propertyType isEqualToString:@"BOOL"] should be_truthy;
         });
         
         it(@"struct", ^{
            NSString *propertyType = [SFMappingRuntime typeForProperty:@"rectProperty"
                                                               ofClass:[TestProperty class]];
            [propertyType isEqualToString:@"CGRect"] should be_truthy;
         });
         
      });
      
   });
   
   describe(@"should not parse property", ^{
      
      it(@"for nonexistent class", ^{
         NSString *propertyType = [SFMappingRuntime typeForProperty:@"rectProperty"
                                                            ofClass:NSClassFromString(@"DefunctKlass")];
         propertyType should be_nil;
      });
      
      it(@"for nonexistent property", ^{
         NSString *propertyType = [SFMappingRuntime typeForProperty:@"unavailable property"
                                                            ofClass:[TestProperty class]];
         propertyType should be_nil;
      });
      
   });
   
});

SPEC_END
