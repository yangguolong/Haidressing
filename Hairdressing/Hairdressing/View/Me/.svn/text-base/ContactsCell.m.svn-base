//
//  ContactsCell.m
//  ismarter2.0_sz
//
//  Created by zx_04 on 15/5/28.
//
//

#import "ContactsCell.h"
//#import "UserModel.h"

@interface ContactsCell ()


@end

@implementation ContactsCell

- (void)awakeFromNib {
    // Initialization code
    _faceImageView.layer.cornerRadius = 2.0f;
    _faceImageView.layer.masksToBounds = YES;
}

+ (ContactsCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"contactsCell";
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactsCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

//- (void)setUserModel:(UserModel *)userModel
//{
//    if (_userModel != userModel) {
//        [_userModel release];
//        _userModel = [userModel retain];
//    }
//    
//    _redImgView.hidden = YES;
//    
//    User *user = _userModel.user;
//    if(_userModel.userCellType == UserCellTypeNewFriend)
//    {
//        self.faceImageView.image = [UIImage imageNamed:@"address_add_friend"];
//        CGRect rect = self.nameLabel.frame;
//        rect.origin.y = 18;
//        self.nameLabel.frame = rect;
//        self.nameLabel.text = @"好友申请";
//        
//        NSString * haveVerify = [[NSUserDefaults standardUserDefaults] objectForKey:@"haveVerify"];
//        if([haveVerify isEqualToString:@"1"])
//        {//红点
//            _redImgView.hidden = NO;
//        }
//    }else if (_userModel.userCellType == UserCellTypeGroupChat)
//    {
//        self.faceImageView.image = [UIImage imageNamed:@"addressbook_group"];
//        CGRect rect = self.nameLabel.frame;
//        rect.origin.y = 18;
//        self.nameLabel.frame = rect;
//        self.nameLabel.text = @"群组";
//    }else if (_userModel.userCellType == UserCellTypeOfficial) { //如果是官方账号行
//        self.faceImageView.image = [UIImage imageNamed:@"addressbook_official_account"];
//        CGRect rect = self.nameLabel.frame;
//        rect.origin.y = 18;
//        self.nameLabel.frame = rect;
//        self.nameLabel.text = @"官方账号";
//    }else if(_userModel.userCellType == UserCellTypeUnit)
//    {
//        self.faceImageView.image = [UIImage imageNamed:@"address_book_unit"];
//        CGRect rect = self.nameLabel.frame;
//        rect.origin.y = 18;
//        self.nameLabel.frame = rect;
//        self.nameLabel.text = @"单位通讯录";
//    }else { //一般的行
//        NSString *portraitPah = [Utility webPathWithPath:user.portrait];
//        NSURL *URL = [NSURL URLWithString:portraitPah];
//        [self.faceImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"default_head"]];
//        CGRect rect = self.nameLabel.frame;
//        rect.origin.y = 18;
//        self.nameLabel.frame = rect;
//        if(user.nickName.length > 0)
//        {
//            self.nameLabel.text = user.nickName;
//        }else if (user.name.length > 0)
//        {
//            self.nameLabel.text = user.name;
//        } else {
//            self.nameLabel.text = user.account;
//        }
//    }
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
