
#import <libkern/OSAtomic.h>
#import "MISLogFormatter.h"

static NSString *const dateFormatString = @"yyyy-MM-dd HH:mm:ss.SSS";


@implementation MISLogFormatter {

}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    static const NSString *LOG_PREFIX = @"MISGeoSmart";
    NSString *logLevel;
    switch (logMessage->logFlag)
    {
        case LOG_FLAG_ERROR : logLevel = @"-E-"; break;
        case LOG_FLAG_WARN  : logLevel = @" W "; break;
        case LOG_FLAG_INFO  : logLevel = @" I "; break;
        case LOG_FLAG_DEBUG : logLevel = @" D "; break;
        default             : logLevel = @" V "; break;
    }
    NSString *dateAndTime = [self stringFromDate:(logMessage->timestamp)];

    return [NSString stringWithFormat:@"%@ [%@-%d]%@|%@>%@(L%d) %@", dateAndTime, LOG_PREFIX,
                                      logMessage->logContext, logLevel,
                                      logMessage.fileName, logMessage.methodName, logMessage->lineNumber,
                                      logMessage->logMsg];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);

    if (loggerCount <= 1)
    {
        // Single-threaded mode.

        if (threadUnsafeDateFormatter == nil)
        {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [threadUnsafeDateFormatter setDateFormat:dateFormatString];
        }

        return [threadUnsafeDateFormatter stringFromDate:date];
    }
    else
    {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.

        NSString *key = @"MyCustomFormatter_NSDateFormatter";

        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];

        if (dateFormatter == nil)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            [dateFormatter setDateFormat:dateFormatString];

            [threadDictionary setObject:dateFormatter forKey:key];
        }

        return [dateFormatter stringFromDate:date];
    }
}

- (void)didAddToLogger:(id <DDLogger>)logger
{
    OSAtomicIncrement32(&atomicLoggerCount);
}
- (void)willRemoveFromLogger:(id <DDLogger>)logger
{
    OSAtomicDecrement32(&atomicLoggerCount);
}
@end
