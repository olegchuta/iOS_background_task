
#import "ChatClientViewController.h"

@implementation ChatClientViewController

@synthesize inputStream, outputStream;


- (void)viewDidLoad {
    [super viewDidLoad];
		
	[self initNetworkCommunication];
    [self sendClientInvitation];
    [self initSendMessageTimer:30];
    [self hideApplication];
    
}

- (void) initNetworkCommunication {
	
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 80, &readStream, &writeStream);
	
	inputStream = (NSInputStream *)readStream;
	outputStream = (NSOutputStream *)writeStream;
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];
	[outputStream open];
}

- (void) initSendMessageTimer:(int)interval
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
}

- (void) sendClientInvitation
{
    NSString *response  = @"iam|iOS_client";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

- (void) hideApplication
{
    // set application to background
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
}

- (IBAction) sendMessage {
    
    NSString *currentTime = [self getCurrentTime];
    
    NSString *response  = @"msg|ping ";
    response = [ response stringByAppendingString:currentTime];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];

    
}

- (NSString *) getCurrentTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:@"hh-mm-ss"];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    [dateFormatter release];
    return currentTime;
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
		
	NSLog(@"stream event %i", streamEvent);
	
	switch (streamEvent) {
			
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
		case NSStreamEventHasBytesAvailable:
			NSLog(@"Data received");
			break;
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
		case NSStreamEventEndEncountered:

            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [theStream release];
            theStream = nil;
			
			break;
		default:
			NSLog(@"Unknown event");
	}
		
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

	[inputStream release];
	[outputStream release];
    [super dealloc];
	
}


@end
