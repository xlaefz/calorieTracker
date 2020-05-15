import UIKit
import BLTNBoard

///Corewrapper to handle feedback inputs on buttom in custom alert views
class FeedbackPageBLTNItem: BLTNPageItem {

    private let feedbackGenerator = SelectionFeedbackGenerator()

    override func actionButtonTapped(sender: UIButton) {

        // Play an haptic feedback

        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super

        super.actionButtonTapped(sender: sender)

    }

    override func alternativeButtonTapped(sender: UIButton) {

        // Play an haptic feedback

        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()

        // Call super

        super.alternativeButtonTapped(sender: sender)

    }

}
