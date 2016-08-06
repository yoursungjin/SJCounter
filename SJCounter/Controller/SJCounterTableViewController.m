//
//  SJCounterTableViewController.m
//  SJCounter
//
//  Created by SJL on 4/25/16.
//  Copyright © 2016 SJL. All rights reserved.
//

#import "SJCounterTableViewController.h"
#import "SJCounter.h"
#import "SJCounterTableViewCell.h"

@interface SJCounterTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *counters;
@end

@implementation SJCounterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewCounter:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.counters = [self populateCounters];
    for (SJCounter *counter in self.counters) {
        [self counter:counter addObserver:self];  //add KVO
    }
    self.tableView.allowsSelection = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self saveCounters])
        NSLog(@"an error occured while saving counters");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Model creation
- (void)insertNewCounter:(id)sender {
    if (!self.counters) {
        self.counters = [[NSMutableArray alloc] init];
    }
    SJCounter* counter = [[SJCounter alloc] init];
    [self counter:counter addObserver:self];//add KVO to counter
    [self.counters insertObject:counter atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self showNamingAlert];
}

- (void)showNamingAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Name this counter" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   SJCounter *counter = [self.counters objectAtIndex: 0];
                                   counter.name = alert.textFields[0].text;
                                   NSLog(@"OK action");
                               }];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = @"New Counter";
        textField.secureTextEntry = NO;
        
    }];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Serialization
- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [paths objectAtIndex: 0];
    return [dirPath stringByAppendingPathComponent: @"counters"];
}

- (id)populateCounters {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
}


- (BOOL)saveCounters {
    return [NSKeyedArchiver archiveRootObject:self.counters toFile:[self filePath]];
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.counters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJCounterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJCounterTableViewCell" forIndexPath:indexPath];
    SJCounter *counter = (SJCounter *)self.counters[indexPath.row];
    cell.nameLabel.text = counter.name;
    cell.numberLabel.text = counter.number;
    cell.stepper.value = [counter.number doubleValue];
    cell.stepper.alpha = tableView.isEditing ?  0.0 : 1.0;
    return cell;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SJCounter * counter = [self.counters objectAtIndex:indexPath.row];
        [self counter:counter removeObserver:self]; //remove KVO
        [self.counters removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *stringToMove = [self.counters objectAtIndex:sourceIndexPath.row];
    [self.counters removeObjectAtIndex:sourceIndexPath.row];
    [self.counters insertObject:stringToMove atIndex:destinationIndexPath.row];
}


#pragma mark - KVO
- (void)counter:(SJCounter *)counter addObserver:(NSObject *)observer {
    [counter addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [counter addObserver:observer forKeyPath:@"number" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)counter:(SJCounter *)counter removeObserver:(NSObject *)observer {
    [counter removeObserver:observer forKeyPath:@"name"];
    [counter removeObserver:observer forKeyPath:@"number"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"name"]) {
        SJCounterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.nameLabel.text = ((SJCounter *)object).name;
    } else if ([keyPath isEqual:@"number"]) {
        for (int i = 0; i < [self.counters count]; i++) {
            if (object == self.counters[i]) {
                SJCounterTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.numberLabel.text = ((SJCounter *)object).number;
                break;
            }
        }
    }
}



#pragma mark - IBAction
- (IBAction)stepperValueChanged:(UIStepper *)sender {
    double value = [sender value];
    CGPoint cursorPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cursorPosition];
    SJCounter *counter = [self.counters objectAtIndex:indexPath.row];
    counter.number = [[NSNumber numberWithDouble:value] stringValue];
}

@end
