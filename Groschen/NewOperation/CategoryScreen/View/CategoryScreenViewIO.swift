protocol CategoryScreenViewInput: AnyObject {
    func reloadTable()
    func markCell(_ cellForRowAt: Int)
    func unmarkCell(_ cellForRowAt: Int)
}

protocol CategoryScreenViewOutput: AnyObject {
    func userSelectedCategory(categoryIndex: Int)
    func getSelectedCategoryTitle() -> String
    func addNewCategory(categoryTitle: String)
    func getNumberOfCategories() -> Int
    func configurCell(index: Int) -> CategoryScreenCell.DisplayData
    func viewWillAppear()
}
