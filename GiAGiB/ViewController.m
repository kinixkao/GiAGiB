//
//  ViewController.m
//  GiAGiB
//
//  Created by kinix on 2018/8/2.
//  Copyright © 2018 kinix. All rights reserved.
//

#import "ViewController.h"
#define DIGIT_SET       @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]
#define DIGIT_LENGTH    4

@interface ViewController ()
{
    UITextField *answerTextField;
    UITextField *giATextField;
    UITextField *giBTextField;
    UILabel *giALabel;
    UILabel *giBLabel;
    UIButton *guessButton;
    UIButton *resetButton;
    UILabel *candidateCountLabel;
    UITableView *historyListTableView;
    NSMutableArray *digitSet;
    NSMutableArray *allPossibleAnswers;
    NSString *guessingAnswer;
    NSMutableArray *historyGuessing;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    digitSet = [NSMutableArray arrayWithArray:DIGIT_SET];
    historyGuessing = [[NSMutableArray alloc] init];
    [self resetAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resetViewFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    if (answerTextField == nil) {
        answerTextField = [[UITextField alloc] init];
        answerTextField.font = [answerTextField.font fontWithSize:30];
        answerTextField.textAlignment = NSTextAlignmentCenter;
        answerTextField.delegate = self;
        [self.view addSubview:answerTextField];
    }
    if (giATextField == nil) {
        giATextField = [[UITextField alloc] init];
        giATextField.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        giATextField.textAlignment = NSTextAlignmentCenter;
        giATextField.keyboardType = UIKeyboardTypeNumberPad;
        giATextField.text = @"";
        giATextField.delegate = self;
        [self.view addSubview:giATextField];
    }
    if (giBTextField == nil) {
        giBTextField = [[UITextField alloc] init];
        giBTextField.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        giBTextField.textAlignment = NSTextAlignmentCenter;
        giBTextField.keyboardType = UIKeyboardTypeNumberPad;
        giBTextField.text = @"";
        giBTextField.delegate = self;
        [self.view addSubview:giBTextField];
    }
    if (giALabel == nil) {
        giALabel = [[UILabel alloc] init];
        giALabel.textAlignment = NSTextAlignmentCenter;
        giALabel.font = [giALabel.font fontWithSize:30];
        giALabel.text = @"A";
        [self.view addSubview:giALabel];
    }
    if (giBLabel == nil) {
        giBLabel = [[UILabel alloc] init];
        giBLabel.textAlignment = NSTextAlignmentCenter;
        giBLabel.font = [giBLabel.font fontWithSize:30];
        giBLabel.text = @"B";
        [self.view addSubview:giBLabel];
    }
    if (guessButton == nil) {
        guessButton = [[UIButton alloc] init];
        [guessButton setTitle:@"Guess" forState:UIControlStateNormal];
        [guessButton.layer setCornerRadius:10];
        [guessButton.layer setMasksToBounds:YES];
        guessButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:167.0/255.0 blue:248.0/255.0 alpha:1.0];
        [guessButton addTarget:self action:@selector(guessAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:guessButton];
    }
    if (resetButton == nil) {
        resetButton = [[UIButton alloc] init];
        [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
        [resetButton.layer setCornerRadius:10];
        [resetButton.layer setMasksToBounds:YES];
        resetButton.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:45.0/255.0 blue:86.0/255.0 alpha:1.0];
        [resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:resetButton];
    }
    if (candidateCountLabel == nil) {
        candidateCountLabel = [[UILabel alloc] init];
        candidateCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:candidateCountLabel];
    }
    if (historyListTableView == nil) {
        historyListTableView = [[UITableView alloc] init];
        historyListTableView.dataSource = self;
        [self.view addSubview:historyListTableView];
    }
}

- (void)resetViewFrame
{
    CGFloat margin = 10.0;
    CGFloat baseY = self.view.frame.size.height/2.0;
    if (guessButton) {
        CGFloat guessButtonWidth = 120.0;
        CGFloat guessButtonHeight = 60.0;
        guessButton.frame = CGRectMake((self.view.frame.size.width/3.0)-(guessButtonWidth/2.0), baseY-guessButtonHeight-margin, guessButtonWidth, guessButtonHeight);
    }
    if (resetButton) {
        CGFloat resetButtonWidth = 120.0;
        CGFloat resetButtonHeight = 60.0;
        resetButton.frame = CGRectMake((self.view.frame.size.width*2/3.0)-(resetButtonWidth/2.0), baseY-resetButtonHeight-margin, resetButtonWidth, resetButtonHeight);
    }
    if (candidateCountLabel) {
        CGFloat candidateCountLabelHeight = 30.0;
        candidateCountLabel.frame = CGRectMake(0, guessButton.frame.origin.y-candidateCountLabelHeight-margin, self.view.frame.size.width, candidateCountLabelHeight);
    }
    if (giATextField) {
        CGFloat giATextFieldWidth = 30.0;
        CGFloat giATextFieldHeight = 30.0;
        giATextField.frame = CGRectMake((self.view.frame.size.width/3.0)-(giATextFieldWidth/2.0), candidateCountLabel.frame.origin.y-giATextFieldHeight-margin, giATextFieldWidth, giATextFieldHeight);
    }
    if (giALabel) {
        CGFloat giALabelWidth = 30.0;
        CGFloat giALabelHeight = 30.0;
        giALabel.frame = CGRectMake(giATextField.frame.origin.x + giATextField.frame.size.width+margin, giATextField.frame.origin.y, giALabelWidth, giALabelHeight);
    }
    if (giBTextField) {
        CGFloat giBTextFieldWidth = 30.0;
        CGFloat giBTextFieldHeight = 30.0;
        giBTextField.frame = CGRectMake((self.view.frame.size.width*2/3.0)-(giBTextFieldWidth/2.0), candidateCountLabel.frame.origin.y-giBTextFieldHeight-margin, giBTextFieldWidth, giBTextFieldHeight);
    }
    if (giBLabel) {
        CGFloat giBLabelWidth = 30.0;
        CGFloat giBLabelHeight = 30.0;
        giBLabel.frame = CGRectMake(giBTextField.frame.origin.x + giBTextField.frame.size.width+margin, giBTextField.frame.origin.y, giBLabelWidth, giBLabelHeight);
    }
    if (answerTextField) {
        CGFloat answerTextFieldHeight = 60.0;
        answerTextField.frame = CGRectMake(0, giATextField.frame.origin.y-answerTextFieldHeight-margin*3, self.view.frame.size.width, answerTextFieldHeight);
    }
    if (historyListTableView) {
        historyListTableView.frame = CGRectMake(0, baseY+margin, self.view.frame.size.width, baseY-margin);
        historyListTableView.bounces = NO;
    }
}

- (void)resetAction
{
    allPossibleAnswers = [self selectCandidate:digitSet collection:@""];
    guessingAnswer = [allPossibleAnswers objectAtIndex:(arc4random()%allPossibleAnswers.count)];
    answerTextField.text = guessingAnswer;
    candidateCountLabel.text = [NSString stringWithFormat:@"All Possible Count: %lu", (unsigned long)allPossibleAnswers.count];
    [historyGuessing removeAllObjects];
    [giATextField resignFirstResponder];
    [giBTextField resignFirstResponder];
    giATextField.text = @"";
    giBTextField.text = @"";
    [historyListTableView reloadData];
}

- (void)guessAction
{
    if (giATextField.text.length == 0 || giBTextField.text.length == 0) return;
    
    NSInteger giA = [giATextField.text integerValue];
    NSInteger giB = [giBTextField.text integerValue];
    NSString *answerText = answerTextField.text;
    if ((giA + giB) > DIGIT_LENGTH || answerText.length != DIGIT_LENGTH) return;
    
    [giATextField resignFirstResponder];
    [giBTextField resignFirstResponder];
    giATextField.text = @"";
    giBTextField.text = @"";
    
    if (historyGuessing == nil) historyGuessing = [[NSMutableArray alloc] init];
    [historyGuessing addObject:[NSString stringWithFormat:@"%@\t\t%ldA%ldB", answerText, (long)giA, (long)giB]];
    guessingAnswer = answerText;
    
    UIAlertController *calculatingAlert = [UIAlertController alertControllerWithTitle:@"Calculating" message:@"Please wait" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:calculatingAlert animated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self->allPossibleAnswers = [self filterOut:self->allPossibleAnswers guess:self->guessingAnswer giA:giA giB:giB];
        self->guessingAnswer = [self pickOne:self->allPossibleAnswers];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [calculatingAlert dismissViewControllerAnimated:YES completion:nil];
            self->answerTextField.text = self->guessingAnswer;
            self->candidateCountLabel.text = [NSString stringWithFormat:@"All Possible Count: %lu", (unsigned long)self->allPossibleAnswers.count];
            [self->historyListTableView reloadData];
        });
    });
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == giATextField || textField == giBTextField) {
        textField.text = @"";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == answerTextField) {
        if (string.length == 0) return YES;
        return [self isEditingValid:resultString];
    }
    
    if (textField == giATextField || textField == giBTextField) {
        NSString *Regex = @"[0-9]";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        BOOL matches = [test evaluateWithObject:string];
        if (matches == NO) return NO;
        NSInteger textValue = [resultString integerValue];
        return (textValue >= 0 && textValue <= DIGIT_LENGTH);
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == giATextField || textField == giBTextField) {
        if (textField.text.length == 0) {
            textField.text = @"0";
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return historyGuessing.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [cell.textLabel.font fontWithSize:26];
    }
    
    cell.textLabel.text = [historyGuessing objectAtIndex:historyGuessing.count - indexPath.row - 1];
    return cell;
}

#pragma mark - Utilties

- (NSMutableArray *)selectCandidate:(NSMutableArray *)fromList collection:(NSString *)collection
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    if (collection.length >= DIGIT_LENGTH) {
        [resultList addObject:collection];
        return resultList;
    }
    
    NSMutableArray *newFromList;
    NSString *newCollection;
    for (int i=0; i<fromList.count; i++) {
        newCollection = [collection stringByAppendingString:[fromList objectAtIndex:i]];
        newFromList = [NSMutableArray arrayWithArray:fromList];
        [newFromList removeObjectAtIndex:i];
        [resultList addObjectsFromArray:[self selectCandidate:newFromList collection:newCollection]];
    }
    return resultList;
}

- (BOOL)isEditingValid:(NSString *)answer
{
    if (answer.length > DIGIT_LENGTH) return NO;
    
    NSString *subString;
    NSNumber *digitNumb;
    NSInteger digitCount;
    NSMutableDictionary *digitCounts = [[NSMutableDictionary alloc] init];
    for (int i=0; i<answer.length; i++) {
        subString = [answer substringWithRange:NSMakeRange(i, 1)];
        digitNumb = [digitCounts objectForKey:subString];
        digitCount = (digitNumb == nil) ? 0 : [digitNumb integerValue];
        [digitCounts setObject:[NSNumber numberWithInteger:++digitCount] forKey:subString];
    }
    
    for (NSString *digit in digitCounts.allKeys) {
        digitNumb = [digitCounts objectForKey:digit];
        if ([digitNumb integerValue] != 1) return NO;
        
        BOOL isValid = NO;
        for (NSString *digitValid in DIGIT_SET) {
            if ([digit isEqualToString:digitValid]) {
                isValid = YES;
                break;
            }
        }
        if (!isValid) return NO;
    }
    return YES;
}

- (NSDictionary *)checkGiAGiB:(NSString *)answer withGuess:(NSString *)guess
{
    if (!answer || !guess || answer.length != guess.length) {
        return nil;
    }
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSUInteger giA = 0;
    NSUInteger giB = 0;
    NSString *cAnswer;
    NSString *cGuess;
    for (int g=0; g<guess.length; g++) {
        cGuess = [guess substringWithRange:NSMakeRange(g, 1)];
        for (int a=0; a<answer.length; a++) {
            cAnswer = [answer substringWithRange:NSMakeRange(a, 1)];
            if (![cGuess isEqualToString:cAnswer]) continue;
            (g == a) ? giA++ : giB++;
        }
    }
    [result setObject:[NSNumber numberWithUnsignedInteger:giA] forKey:@"A"];
    [result setObject:[NSNumber numberWithUnsignedInteger:giB] forKey:@"B"];
    return result;
}

- (NSMutableArray *)filterOut:(NSMutableArray *)possibleList guess:(NSString *)guess giA:(NSUInteger)giA giB:(NSUInteger)giB
{
    NSDictionary *result;
    NSMutableArray *newPossibleList = [NSMutableArray arrayWithArray:possibleList];
    for (NSString *candidate in possibleList) {
        result = [self checkGiAGiB:candidate withGuess:guess];
        if (!result) continue;
        
        NSUInteger resultA = [[result objectForKey:@"A"] unsignedIntegerValue];
        NSUInteger resultB = [[result objectForKey:@"B"] unsignedIntegerValue];
        if (resultA == giA && resultB == giB) continue;
        [newPossibleList removeObject:candidate];
    }
    return newPossibleList;
}

- (BOOL)isFit:(NSString *)string criterion:(NSMutableArray *)criterion
{
    if (string.length != criterion.count) {
        return NO;
    }
    
    BOOL isFit = YES;
    NSString *digit;
    NSString *cDigit;
    for (int i=0; i<string.length; i++) {
        cDigit = [criterion objectAtIndex:i];
        if (cDigit.length == 0) continue;
        cDigit = [cDigit substringWithRange:NSMakeRange(0, 1)]; // Make sure to get the character
        digit = [string substringWithRange:NSMakeRange(i, 1)];
        if ([digit isEqualToString:cDigit] == NO) {
            return NO;
        }
    }
    return isFit;
}

- (NSString *)pickOne:(NSArray *)possibleList
{
    NSMutableArray *guessDigits = [[NSMutableArray alloc] init];
    for (int i=0; i<DIGIT_LENGTH; i++) {
        [guessDigits addObject:@""];
    }
    
    NSMutableArray *candidateList = [NSMutableArray arrayWithArray:possibleList];
    NSMutableArray *newCandidateList = [NSMutableArray arrayWithArray:possibleList];
    for (int i=0; i<DIGIT_LENGTH; i++) {
        NSUInteger maxDigitCount = 0;
        NSUInteger maxDigitIndex = 0;
        NSString *maxCountDigit;
        NSMutableArray *analysisResult = [[NSMutableArray alloc] init];
        for (NSString *candidate in candidateList) {
            if ([self isFit:candidate criterion:guessDigits] == NO) {
                [newCandidateList removeObject:candidate];
                continue;
            }
            
            NSString *guessDigit;
            for (int j=0; j<candidate.length; j++) {
                guessDigit = [guessDigits objectAtIndex:j];
                if (guessDigit.length > 0) continue;
                
                NSMutableDictionary *digitCounts;
                if (analysisResult.count > j) {
                    digitCounts = [analysisResult objectAtIndex:j];
                } else {
                    digitCounts = [[NSMutableDictionary alloc] init];
                    [analysisResult addObject:digitCounts];
                }
                
                NSString *digit = [candidate substringWithRange:NSMakeRange(j, 1)];
                NSNumber *digitCount = [digitCounts objectForKey:digit];
                if (digitCount == nil) digitCount = [NSNumber numberWithInteger:0];
                digitCount = [NSNumber numberWithInteger:[digitCount integerValue]+1];
                [digitCounts setObject:digitCount forKey:digit];
                if ([digitCount integerValue] > maxDigitCount) {
                    maxDigitCount = [digitCount integerValue];
                    maxDigitIndex = j;
                    maxCountDigit = digit;
                }
            }
        }
        if (maxCountDigit) {
            [guessDigits replaceObjectAtIndex:maxDigitIndex withObject:maxCountDigit];
        }
        candidateList = [NSMutableArray arrayWithArray:newCandidateList];
    }
    
    NSString *guess;
    if (guessDigits.count != DIGIT_LENGTH) {
        guess = [possibleList objectAtIndex:(arc4random()%possibleList.count)];
    } else {
        guess = [[NSString alloc] init];
        for (NSString *guessDigit in guessDigits) {
            guess = [guess stringByAppendingString:guessDigit];
        }
    }
    return guess;
}

@end
