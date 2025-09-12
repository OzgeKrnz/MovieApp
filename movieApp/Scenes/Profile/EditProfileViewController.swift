//
//  EditProfileViewController.swift
//  movieApp
//
//  Created by özge kurnaz on 11.08.2025.
//

import UIKit
import FirebaseAuth

final class EditProfileViewController: BaseViewController {

    var editProfileViewModel: EditProfileViewModel!

    // Titles (textfield üstü)
    private let usernameTitleLabel = UILabel()
    private let emailTitleLabel = UILabel()
    private let passwordTitleLabel = UILabel()

    // Fields
    private let usernameTextField = UITextField()
    private let emailTextField = UITextField()      // read-only gibi davranacağız
    private let passwordTextField = UITextField()

    // Button + loader
    private let primarySaveButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    // Layout constants
    private let inset: CGFloat = 20
    private let fieldHeight: CGFloat = 48
    private let corner: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"

        
        view.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)

        configureNavigationBarAppearance()
        configureUI()
        layoutUI()
        bindViewModel()
        editProfileViewModel?.loadCurrentUser()
    }

    // MARK: - NavBar: başlık beyaz
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 39/255, green: 63/255, blue: 79/255, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white      // back/close icons
    }

    // MARK: - Style helpers
    private func makeTitleLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = UIColor.white.withAlphaComponent(0.85) // koyu zeminde okunaklı
        return l
    }

    private func makeTextField(_ placeholder: String, secure: Bool = false, readOnly: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.isSecureTextEntry = secure
        tf.isEnabled = !readOnly
        tf.backgroundColor = .white
        tf.textColor = .label
        tf.layer.cornerRadius = corner
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.separator.cgColor
        tf.clearButtonMode = readOnly ? .never : .whileEditing
        tf.heightAnchor.constraint(equalToConstant: fieldHeight).isActive = true

        // İç boşluklar (left/right padding)
        let left = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: fieldHeight))
        let right = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: fieldHeight))
        tf.leftView = left; tf.leftViewMode = .always
        tf.rightView = right; tf.rightViewMode = .always
        return tf
    }

    // MARK: - Configure
    private func configureUI() {
        // Labels
        usernameTitleLabel.text = "Username"
        emailTitleLabel.text = "Email"
        passwordTitleLabel.text = "Password"

        [usernameTitleLabel, emailTitleLabel, passwordTitleLabel].enumerated().forEach { idx, label in
            let txt = [ "Username", "Email", "Password" ][idx]
            let made = makeTitleLabel(txt)
            label.font = made.font
            label.textColor = made.textColor
            label.text = txt
        }

        // TextFields
        usernameTextField.font = .systemFont(ofSize: 16)
        passwordTextField.font = .systemFont(ofSize: 16)
        emailTextField.font = .systemFont(ofSize: 16)

        let userTF = makeTextField("Enter username")
        userTF.autocapitalizationType = .none
        userTF.autocorrectionType = .no
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.layer.cornerRadius = userTF.layer.cornerRadius
        usernameTextField.layer.borderWidth = userTF.layer.borderWidth
        usernameTextField.layer.borderColor = userTF.layer.borderColor
        usernameTextField.backgroundColor = userTF.backgroundColor
        usernameTextField.textColor = userTF.textColor
        usernameTextField.leftView = userTF.leftView; usernameTextField.leftViewMode = .always
        usernameTextField.rightView = userTF.rightView; usernameTextField.rightViewMode = .always
        usernameTextField.clearButtonMode = .whileEditing

        let mailTF = makeTextField("Email", readOnly: true)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.layer.cornerRadius = mailTF.layer.cornerRadius
        emailTextField.layer.borderWidth = mailTF.layer.borderWidth
        emailTextField.layer.borderColor = mailTF.layer.borderColor
        emailTextField.backgroundColor = mailTF.backgroundColor
        emailTextField.textColor = mailTF.textColor
        emailTextField.leftView = mailTF.leftView; emailTextField.leftViewMode = .always
        emailTextField.rightView = mailTF.rightView; emailTextField.rightViewMode = .always
        emailTextField.isEnabled = false
        emailTextField.text = Auth.auth().currentUser?.email

        let passTF = makeTextField("Enter password", secure: true)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.layer.cornerRadius = passTF.layer.cornerRadius
        passwordTextField.layer.borderWidth = passTF.layer.borderWidth
        passwordTextField.layer.borderColor = passTF.layer.borderColor
        passwordTextField.backgroundColor = passTF.backgroundColor
        passwordTextField.textColor = passTF.textColor
        passwordTextField.leftView = passTF.leftView; passwordTextField.leftViewMode = .always
        passwordTextField.rightView = passTF.rightView; passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .whileEditing

        // Save Button – modern filled görünüm
        var conf = UIButton.Configuration.filled()
        conf.title = "Save Changes"
        conf.cornerStyle = .large
        conf.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        conf.baseBackgroundColor = UIColor(red: 255/255, green: 160/255, blue: 0, alpha: 1)
        conf.baseForegroundColor = .white
        primarySaveButton.configuration = conf
        primarySaveButton.layer.cornerRadius = corner
        primarySaveButton.layer.masksToBounds = true
        primarySaveButton.addTarget(self, action: #selector(handleSaveTapped), for: .touchUpInside)

        activityIndicator.hidesWhenStopped = true
    }

    // MARK: - Layout
    private func layoutUI() {
        let guide = view.safeAreaLayoutGuide

        [usernameTitleLabel, usernameTextField,
         emailTitleLabel, emailTextField,
         passwordTitleLabel, passwordTextField,
         primarySaveButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // Username
            usernameTitleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            usernameTitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            usernameTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -inset),

            usernameTextField.topAnchor.constraint(equalTo: usernameTitleLabel.bottomAnchor, constant: 6),
            usernameTextField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            usernameTextField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset),
            usernameTextField.heightAnchor.constraint(equalToConstant: fieldHeight),

            // Email
            emailTitleLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            emailTitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            emailTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -inset),

            emailTextField.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 6),
            emailTextField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            emailTextField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset),
            emailTextField.heightAnchor.constraint(equalToConstant: fieldHeight),

            // Password
            passwordTitleLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            passwordTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -inset),

            passwordTextField.topAnchor.constraint(equalTo: passwordTitleLabel.bottomAnchor, constant: 6),
            passwordTextField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            passwordTextField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset),
            passwordTextField.heightAnchor.constraint(equalToConstant: fieldHeight),

            // Save button
            primarySaveButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            primarySaveButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            primarySaveButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset),
            primarySaveButton.heightAnchor.constraint(equalToConstant: 52),

            activityIndicator.centerYAnchor.constraint(equalTo: primarySaveButton.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset)
        ])
    }

    // MARK: - ViewModel binding
    private func bindViewModel() {
        editProfileViewModel?.onStateChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .idle:
                activityIndicator.stopAnimating()
                primarySaveButton.isEnabled = true
            case .loading:
                activityIndicator.startAnimating()
                primarySaveButton.isEnabled = false
            case .success:
                activityIndicator.stopAnimating()
                primarySaveButton.isEnabled = true
                usernameTextField.text = editProfileViewModel.username
                emailTextField.text = Auth.auth().currentUser?.email
            case .error:
                activityIndicator.stopAnimating()
                primarySaveButton.isEnabled = true
            }
        }
    }

    // MARK: - Actions
    @objc private func handleSaveTapped() {
        editProfileViewModel.username = usernameTextField.text ?? ""
        editProfileViewModel.saveProfile()
    }
}
