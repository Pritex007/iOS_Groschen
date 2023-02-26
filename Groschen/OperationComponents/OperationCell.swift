import Foundation
import UIKit

final class OperationCell: UITableViewCell {
    
    struct DisplayData {
        let category: String
        let comment: String?
        let time: String
        let amountDisplayData: AmountView.DisplayData
    }
    
    private enum Constants {
        enum Cell {
            static let cornerRadius: CGFloat = 10.0
            static let topBottomIndent: CGFloat = 4
            static let leftRightIndent: CGFloat = 16
        }
        enum CategoryLabel {
            static let leadingIndent: CGFloat = 16.0
            static let trailingIndentFromTimeLabel: CGFloat = 30.0
            static let topIndent: CGFloat = 8.0
            
            static let height: CGFloat = Other.labelHeight
        }
        enum CommentLabel {
            static let numberOfLines = 2
            
            static let leadingIndent: CGFloat = CategoryLabel.leadingIndent
            static let topIndentFromCategoryLabel: CGFloat = 8.0
            static let bottomIndent: CGFloat = 11.0
        }
        enum TimeLabel {
            static let trailingIndent: CGFloat = 25.0
            static let topIndent: CGFloat = CategoryLabel.topIndent
            
            static let height: CGFloat = Other.labelHeight
        }
        //white rounded rectangle
        enum AmountView {
            static let leadingIndentFromCommentLabel: CGFloat = 20.0
            static let trailingIndent: CGFloat = 24.0
            static let minTopIndentFromTimaLabel: CGFloat = 4.0
            static let minBottomIndent: CGFloat = 8.0
            
            //includes 14 symbols in amount (includung group separators)
            static let maxWidth: CGFloat = 155.0
            static let height: CGFloat = 25.0
        }
        enum ChevronImage {
            static let leadingIndentFromAmountView: CGFloat = 8.0
            static let trailingIndent: CGFloat = 8.0
            
            static let width: CGFloat = 8.0
            static let height: CGFloat = 16.0
        }
        
        enum Font {
            static let titleTextSize: CGFloat = 17.0
            static let otherTextSize: CGFloat = 15.0
        }
        private enum Other {
            static let labelHeight: CGFloat = 18.0
        }
    }

    
    private let categoryLabel = UILabel()
    private let commentLabel = UILabel()
    private let timeLabel = UILabel()
    private let amountView = AmountView()
    private let chevronImageView = UIImageView()

    
    required init?(coder: NSCoder) {
        super.init(coder: NSCoder())
        setupCell()
        setupSubiews()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupSubiews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryLabel.text = ""
        commentLabel.text = ""
        timeLabel.text = ""
        amountView.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.Cell.topBottomIndent,
                                                                     left: Constants.Cell.leftRightIndent,
                                                                     bottom: Constants.Cell.topBottomIndent,
                                                                     right: Constants.Cell.leftRightIndent))
    }
    
    // MARK: Setups
    private func setupCell() {
        contentView.backgroundColor = UIColor(named: "backgroundColor")
        
        contentView.layer.cornerRadius = Constants.Cell.cornerRadius
        contentView.layer.masksToBounds = true
    }

    private func setupSubiews() {
        
        contentView.addSubview(amountView)
        amountView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        amountView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(commentLabel)
        commentLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        commentLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        contentView.addSubview(timeLabel)
        contentView.addSubview(chevronImageView)
        
        // MARK: Subviews appearance
        
        chevronImageView.image = UIImage(named: "chevron.forward")

        //colors setup
        commentLabel.textColor = .systemGray
        amountView.backgroundColor = .white
        chevronImageView.tintColor = .black
        
        //labels text customization
        setupFonts()
        timeLabel.textAlignment = .right
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.numberOfLines = Constants.CommentLabel.numberOfLines
        
        
        //constraints setup
        setupSubviewsConstraints()
    }
    
    private func setupFonts() {
        categoryLabel.font = UIFont.systemFont(ofSize: Constants.Font.titleTextSize)
        commentLabel.font = UIFont.systemFont(ofSize: Constants.Font.titleTextSize)
        timeLabel.font = UIFont.systemFont(ofSize: Constants.Font.titleTextSize)
    }
    
    private func setupSubviewsConstraints() {
        // MARK: deactivation autoresizing for all views
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        amountView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // MARK: categoryLabel constraints activation
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Constants.CategoryLabel.leadingIndent),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Constants.CategoryLabel.topIndent),
            categoryLabel.heightAnchor.constraint(equalToConstant: Constants.CategoryLabel.height),
            
            // MARK: commentLabel constraints activation
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: Constants.CommentLabel.leadingIndent),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -Constants.CommentLabel.bottomIndent),
            
            // MARK: amountView constraints activation
            amountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -Constants.AmountView.trailingIndent),
            amountView.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.AmountView.maxWidth),
            amountView.heightAnchor.constraint(equalToConstant: Constants.AmountView.height),
            amountView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor,
                                               constant: -Constants.AmountView.minBottomIndent),
            
            // MARK: timeLabel constraints activation
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -Constants.TimeLabel.trailingIndent),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: Constants.TimeLabel.topIndent),
            timeLabel.heightAnchor.constraint(equalToConstant: Constants.TimeLabel.height),
            
            // MARK: chevronImageView constraints activation
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -Constants.ChevronImage.trailingIndent),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: Constants.ChevronImage.width),
            chevronImageView.heightAnchor.constraint(equalToConstant: Constants.ChevronImage.height),
            
            // MARK: related constraints activation
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor,
                                                    constant: -Constants.CategoryLabel.trailingIndentFromTimeLabel),
            
            commentLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                              constant: Constants.CommentLabel.topIndentFromCategoryLabel),
            
            amountView.leadingAnchor.constraint(greaterThanOrEqualTo: commentLabel.trailingAnchor,
                                                constant: Constants.AmountView.leadingIndentFromCommentLabel),
            amountView.centerYAnchor.constraint(equalTo: commentLabel.centerYAnchor),
            amountView.topAnchor.constraint(greaterThanOrEqualTo: timeLabel.bottomAnchor,
                                            constant: Constants.AmountView.minTopIndentFromTimaLabel)

        ])
    }
    // MARK: setups end
    
    
    func configure(displayData: DisplayData) {
        categoryLabel.text = displayData.category
        commentLabel.text = displayData.comment
        timeLabel.text = displayData.time
        amountView.configure(displayData: displayData.amountDisplayData)
    }
}
