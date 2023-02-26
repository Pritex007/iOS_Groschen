protocol CategoryAdderViewDelegate: AnyObject {
    func didTapCloseButton()
    func adderViewWantsToAddNewCategory(categoryTitle: String)
}
