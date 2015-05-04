
#import <Foundation/Foundation.h>

static NSString *const dateFormatString;

@interface MISLogFormatter : NSObject <DDLogFormatter>
{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}


@end
