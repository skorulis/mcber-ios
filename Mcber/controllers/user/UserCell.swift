//  Created by Alexander Skorulis on 8/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

final class UserCell: ThemedCollectionViewCell, AutoSizeModelCell {
    
    let usernameLabel = UILabel()
    let currencyLabel = UILabel()
    let avatarCountLabel = UILabel()
    
    static var sizingCell: UserCell = setupCell(cell: UserCell())
    typealias ModelType = UserModel
    var model: UserModel? {
        didSet {
            guard let model = model else { return }
            usernameLabel.text = model.email ?? "Unknown"
            currencyLabel.text = "Credits:  \(model.currency)"
            avatarCountLabel.text = "Avatars: \(model.avatars.count)"
        }
    }
    
    override func buildView(theme: ThemeService) {
        contentView.addSubview(usernameLabel)
        contentView.addSubview(currencyLabel)
        contentView.addSubview(avatarCountLabel)
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
    }
    
}
