import UIKit

class KeyboardAdjustments {
    
    private let view: UIView?
    
    init(view: UIView) {
        self.view = view
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            // 현재 선택된 텍스트 필드를 알아냅니다.
            if let activeTextField = findActiveTextField() {
                // 텍스트 필드가 화면에 표시되는 영역 계산
                let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: self.view)
                let visibleAreaHeight = view!.frame.height - keyboardHeight
                
                // 텍스트 필드가 키보드와 겹친다면 뷰를 올려줍니다.
                if textFieldFrame.maxY > visibleAreaHeight {
                    let offset = textFieldFrame.maxY - visibleAreaHeight + 50
                    animateViewMoving(up: true, offset: offset)
                } else {
                    // 텍스트 필드가 키보드와 겹치지 않는다면 뷰를 원래 위치로 복원합니다.
                    animateViewMoving(up: false, offset: 0)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // 키보드가 사라질 때 뷰를 원래 위치로 복원합니다.
        animateViewMoving(up: false, offset: 0)
    }
    
    // 뷰의 위치를 변경하는 메서드
    func animateViewMoving(up: Bool, offset: CGFloat) {
        let duration = 0.3
        UIView.animate(withDuration: duration) {
            self.view!.frame.origin.y = up ? -offset : 0
        }
    }
    
    // 현재 선택된 텍스트 필드를 찾는 메서드
    func findActiveTextField() -> UITextField? {
        // 해당 뷰 컨트롤러 내에서 UITextField에 firstResponder가 된 것을 찾아 반환합니다.
        for view in self.view!.subviews {
            if let textField = view as? UITextField, textField.isFirstResponder {
                return textField
            }
        }
        return nil
    }
}
