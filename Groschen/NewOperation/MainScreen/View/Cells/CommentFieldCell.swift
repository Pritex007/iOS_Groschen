import UIKit

final class CommentFieldCell: UITableViewCell {
    
    private enum Constants {
        enum Cell {
            static let topBottomIndent: CGFloat = 0
            static let leftRightIndent: CGFloat = 16
            static let topInset: CGFloat = 30
        }
        enum ToolBar {
            static let height: CGFloat = 50
        }
        enum TextView {
            static let fontHeight: CGFloat = 17
            static let maxNumberOfCharacters: Int = 200
        }
    }
    
    private let textView: UITextView = UITextView() 
    
    weak var delegate: GrowingCellProtocol?
    weak var dataDelegate: CellDataDelegate?
    
    static let reuseId: String = "CommentFieldCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConfigurations()
        setupConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConfigurations()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.Cell.topBottomIndent,
                                                                     left: Constants.Cell.leftRightIndent,
                                                                     bottom: Constants.Cell.topBottomIndent,
                                                                     right: Constants.Cell.leftRightIndent))
        textView.textContainerInset.top = Constants.Cell.topInset
    }
    
    func configure(comment: String) {
        guard !comment.isEmpty else { return }
        textView.text = comment
        delegate?.updateHeightOfRow(newText: textView.text)
        textView.textColor = .label
    }
    
    private func setupConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    private func setupConfigurations() {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: Constants.ToolBar.height))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(amountDone))
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
        
        contentView.addSubview(textView)
        
        textView.keyboardType = .default
        textView.font =  .systemFont(ofSize: Constants.TextView.fontHeight, weight: .regular)
        textView.textColor = .systemGray
        textView.backgroundColor = .none
        
        textView.delegate = self
        textView.textContainer.lineFragmentPadding = 0
        textView.text = "Комментарии"
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
    }
    
    func selectedCell() {
        textView.becomeFirstResponder()
    }
    
    @objc
    private func amountDone() {
        textView.endEditing(true)
    }
}

// MARK: - UITextViewDelegate

extension CommentFieldCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Комментарии"
            textView.textColor = UIColor.systemGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateHeightOfRow(newText: textView.text)
        dataDelegate?.translateComment(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= Constants.TextView.maxNumberOfCharacters
    }
}
