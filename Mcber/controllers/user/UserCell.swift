//  Created by Alexander Skorulis on 8/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

final class UserCell: ThemedCollectionViewCell, AutoSizeModelCell {
    
    let usernameLabel = UILabel()
    let currencyLabel = UILabel()
    let avatarCountLabel = UILabel()
    let buyAvatarButton = UIButton()
    let optionsButton = UIButton()
    
    static var sizingCell: UserCell = setupCell(cell: UserCell())
    typealias ModelType = UserModel
    var model: UserModel? {
        didSet {
            guard let model = model else { return }
            usernameLabel.text = model.email ?? "Unknown"
            currencyLabel.text = "Credits:  \(model.currency)"
            avatarCountLabel.text = "Avatars: \(model.avatars.count) / \(model.maxAvatars)"
        }
    }
    
    override func buildView(theme: ThemeService) {
        buyAvatarButton.setTitleColor(UIColor.blue, for: .normal)
        buyAvatarButton.setTitle("+", for: .normal)
        
        let cogIcon = FAKFontAwesome.cogIcon(withSize: 40)
        cogIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: theme.color.defaultText)
        optionsButton.setAttributedTitle(cogIcon?.attributedString(), for: .normal)
        
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(currencyLabel)
        contentView.addSubview(avatarCountLabel)
        contentView.addSubview(buyAvatarButton)
        contentView.addSubview(optionsButton)
    }
    
    override func buildLayout(theme: ThemeService) {
        usernameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(theme.padding.top)
        }
        currencyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom).offset(theme.padding.innerY)
            make.left.equalToSuperview()
        }
        avatarCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currencyLabel.snp.bottom).offset(theme.padding.innerY)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(theme.padding.bot)
        }
        buyAvatarButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarCountLabel)
            make.left.equalTo(avatarCountLabel.snp.right).offset(10);
        }
        optionsButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview().inset(theme.padding.edges)
        }
    }
    
}
