/********************************************************************************
** Form generated from reading UI file 'proxyman.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_PROXYMAN_H
#define UI_PROXYMAN_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QCommandLinkButton>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_ProxyMan
{
public:
    QGroupBox *targetGroup;
    QWidget *layoutWidget;
    QGridLayout *targetElems;
    QCheckBox *checkBash;
    QCheckBox *checkEnv;
    QCheckBox *checkGsettings;
    QCheckBox *checkApt;
    QCheckBox *checkNpm;
    QCheckBox *checkDropbox;
    QCheckBox *checkGit;
    QCheckBox *checkSelectAll;
    QGroupBox *groupBox;
    QGridLayout *configGrid;
    QSpinBox *HttpsPort;
    QLabel *lblFtpPort;
    QLabel *lblFtpHost;
    QLabel *lblHttpPort;
    QSpinBox *HttpPort;
    QLabel *lblHttpsHost;
    QLineEdit *HttpHost;
    QCheckBox *useAuth;
    QCheckBox *useSame;
    QLineEdit *password;
    QLineEdit *HttpsHost;
    QLabel *lblHttpsPort;
    QSpinBox *FtpPort;
    QLabel *lblUsername;
    QLineEdit *FtpHost;
    QLabel *lblPassword;
    QLineEdit *username;
    QLabel *lblHttpHost;
    QWidget *layoutWidget1;
    QHBoxLayout *actionWidgets;
    QComboBox *actionsCombo;
    QCommandLinkButton *actionCmd;

    void setupUi(QWidget *ProxyMan)
    {
        if (ProxyMan->objectName().isEmpty())
            ProxyMan->setObjectName(QStringLiteral("ProxyMan"));
        ProxyMan->resize(481, 402);
        QSizePolicy sizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(ProxyMan->sizePolicy().hasHeightForWidth());
        ProxyMan->setSizePolicy(sizePolicy);
        ProxyMan->setStyleSheet(QLatin1String("background-color: #fff;\n"
"border: 1px solid black;"));
        targetGroup = new QGroupBox(ProxyMan);
        targetGroup->setObjectName(QStringLiteral("targetGroup"));
        targetGroup->setGeometry(QRect(10, 10, 461, 121));
        targetGroup->setFlat(false);
        targetGroup->setCheckable(false);
        targetGroup->setChecked(false);
        layoutWidget = new QWidget(targetGroup);
        layoutWidget->setObjectName(QStringLiteral("layoutWidget"));
        layoutWidget->setGeometry(QRect(10, 40, 441, 76));
        targetElems = new QGridLayout(layoutWidget);
        targetElems->setSpacing(6);
        targetElems->setContentsMargins(11, 11, 11, 11);
        targetElems->setObjectName(QStringLiteral("targetElems"));
        targetElems->setContentsMargins(1, 1, 1, 1);
        checkBash = new QCheckBox(layoutWidget);
        checkBash->setObjectName(QStringLiteral("checkBash"));
        checkBash->setStyleSheet(QStringLiteral("border: none"));

        targetElems->addWidget(checkBash, 0, 0, 1, 1);

        checkEnv = new QCheckBox(layoutWidget);
        checkEnv->setObjectName(QStringLiteral("checkEnv"));
        checkEnv->setStyleSheet(QStringLiteral("border: none"));

        targetElems->addWidget(checkEnv, 0, 1, 1, 1);

        checkGsettings = new QCheckBox(layoutWidget);
        checkGsettings->setObjectName(QStringLiteral("checkGsettings"));
        checkGsettings->setStyleSheet(QStringLiteral("border: none"));

        targetElems->addWidget(checkGsettings, 0, 2, 1, 1);

        checkApt = new QCheckBox(layoutWidget);
        checkApt->setObjectName(QStringLiteral("checkApt"));
        checkApt->setStyleSheet(QStringLiteral("border: none"));

        targetElems->addWidget(checkApt, 1, 0, 1, 1);

        checkNpm = new QCheckBox(layoutWidget);
        checkNpm->setObjectName(QStringLiteral("checkNpm"));
        checkNpm->setStyleSheet(QStringLiteral("border: none	"));

        targetElems->addWidget(checkNpm, 1, 1, 1, 1);

        checkDropbox = new QCheckBox(layoutWidget);
        checkDropbox->setObjectName(QStringLiteral("checkDropbox"));
        checkDropbox->setStyleSheet(QStringLiteral("border: none"));

        targetElems->addWidget(checkDropbox, 1, 2, 1, 1);

        checkGit = new QCheckBox(layoutWidget);
        checkGit->setObjectName(QStringLiteral("checkGit"));

        targetElems->addWidget(checkGit, 2, 0, 1, 1);

        checkSelectAll = new QCheckBox(targetGroup);
        checkSelectAll->setObjectName(QStringLiteral("checkSelectAll"));
        checkSelectAll->setGeometry(QRect(120, 10, 85, 20));
        checkSelectAll->setStyleSheet(QStringLiteral("border: none"));
        groupBox = new QGroupBox(ProxyMan);
        groupBox->setObjectName(QStringLiteral("groupBox"));
        groupBox->setGeometry(QRect(10, 190, 461, 201));
        configGrid = new QGridLayout(groupBox);
        configGrid->setSpacing(6);
        configGrid->setContentsMargins(11, 11, 11, 11);
        configGrid->setObjectName(QStringLiteral("configGrid"));
        HttpsPort = new QSpinBox(groupBox);
        HttpsPort->setObjectName(QStringLiteral("HttpsPort"));
        HttpsPort->setMaximum(65535);

        configGrid->addWidget(HttpsPort, 5, 3, 1, 1);

        lblFtpPort = new QLabel(groupBox);
        lblFtpPort->setObjectName(QStringLiteral("lblFtpPort"));
        lblFtpPort->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(lblFtpPort, 6, 2, 1, 1);

        lblFtpHost = new QLabel(groupBox);
        lblFtpHost->setObjectName(QStringLiteral("lblFtpHost"));
        lblFtpHost->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(lblFtpHost, 6, 0, 1, 1);

        lblHttpPort = new QLabel(groupBox);
        lblHttpPort->setObjectName(QStringLiteral("lblHttpPort"));
        lblHttpPort->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(lblHttpPort, 0, 2, 1, 1);

        HttpPort = new QSpinBox(groupBox);
        HttpPort->setObjectName(QStringLiteral("HttpPort"));
        HttpPort->setMaximum(65535);

        configGrid->addWidget(HttpPort, 0, 3, 1, 1);

        lblHttpsHost = new QLabel(groupBox);
        lblHttpsHost->setObjectName(QStringLiteral("lblHttpsHost"));
        lblHttpsHost->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(lblHttpsHost, 5, 0, 1, 1);

        HttpHost = new QLineEdit(groupBox);
        HttpHost->setObjectName(QStringLiteral("HttpHost"));

        configGrid->addWidget(HttpHost, 0, 1, 1, 1);

        useAuth = new QCheckBox(groupBox);
        useAuth->setObjectName(QStringLiteral("useAuth"));
        useAuth->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(useAuth, 1, 0, 1, 2);

        useSame = new QCheckBox(groupBox);
        useSame->setObjectName(QStringLiteral("useSame"));
        useSame->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(useSame, 4, 0, 1, 2);

        password = new QLineEdit(groupBox);
        password->setObjectName(QStringLiteral("password"));
        password->setInputMethodHints(Qt::ImhSensitiveData);

        configGrid->addWidget(password, 3, 1, 1, 1);

        HttpsHost = new QLineEdit(groupBox);
        HttpsHost->setObjectName(QStringLiteral("HttpsHost"));

        configGrid->addWidget(HttpsHost, 5, 1, 1, 1);

        lblHttpsPort = new QLabel(groupBox);
        lblHttpsPort->setObjectName(QStringLiteral("lblHttpsPort"));
        lblHttpsPort->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(lblHttpsPort, 5, 2, 1, 1);

        FtpPort = new QSpinBox(groupBox);
        FtpPort->setObjectName(QStringLiteral("FtpPort"));
        FtpPort->setMaximum(65535);

        configGrid->addWidget(FtpPort, 6, 3, 1, 1);

        lblUsername = new QLabel(groupBox);
        lblUsername->setObjectName(QStringLiteral("lblUsername"));
        lblUsername->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(lblUsername, 2, 0, 1, 1);

        FtpHost = new QLineEdit(groupBox);
        FtpHost->setObjectName(QStringLiteral("FtpHost"));

        configGrid->addWidget(FtpHost, 6, 1, 1, 1);

        lblPassword = new QLabel(groupBox);
        lblPassword->setObjectName(QStringLiteral("lblPassword"));
        lblPassword->setStyleSheet(QStringLiteral("border: none"));

        configGrid->addWidget(lblPassword, 3, 0, 1, 1);

        username = new QLineEdit(groupBox);
        username->setObjectName(QStringLiteral("username"));

        configGrid->addWidget(username, 2, 1, 1, 1);

        lblHttpHost = new QLabel(groupBox);
        lblHttpHost->setObjectName(QStringLiteral("lblHttpHost"));
        lblHttpHost->setStyleSheet(QStringLiteral("border: none"));
        lblHttpHost->setScaledContents(false);

        configGrid->addWidget(lblHttpHost, 0, 0, 1, 1);

        configGrid->setColumnStretch(0, 1);
        configGrid->setColumnStretch(1, 2);
        configGrid->setColumnStretch(2, 1);
        configGrid->setColumnStretch(3, 1);
        HttpHost->raise();
        lblFtpHost->raise();
        FtpPort->raise();
        lblHttpsHost->raise();
        lblFtpPort->raise();
        HttpsPort->raise();
        lblHttpPort->raise();
        FtpHost->raise();
        HttpPort->raise();
        lblHttpHost->raise();
        lblHttpsPort->raise();
        useAuth->raise();
        password->raise();
        username->raise();
        useSame->raise();
        lblUsername->raise();
        lblPassword->raise();
        HttpsHost->raise();
        layoutWidget1 = new QWidget(ProxyMan);
        layoutWidget1->setObjectName(QStringLiteral("layoutWidget1"));
        layoutWidget1->setGeometry(QRect(10, 140, 461, 39));
        actionWidgets = new QHBoxLayout(layoutWidget1);
        actionWidgets->setSpacing(6);
        actionWidgets->setContentsMargins(11, 11, 11, 11);
        actionWidgets->setObjectName(QStringLiteral("actionWidgets"));
        actionWidgets->setContentsMargins(2, 0, 2, 0);
        actionsCombo = new QComboBox(layoutWidget1);
        actionsCombo->setObjectName(QStringLiteral("actionsCombo"));

        actionWidgets->addWidget(actionsCombo);

        actionCmd = new QCommandLinkButton(layoutWidget1);
        actionCmd->setObjectName(QStringLiteral("actionCmd"));

        actionWidgets->addWidget(actionCmd);

        actionWidgets->setStretch(0, 1);
        QWidget::setTabOrder(checkSelectAll, checkBash);
        QWidget::setTabOrder(checkBash, checkEnv);
        QWidget::setTabOrder(checkEnv, checkGsettings);
        QWidget::setTabOrder(checkGsettings, checkApt);
        QWidget::setTabOrder(checkApt, checkNpm);
        QWidget::setTabOrder(checkNpm, checkDropbox);
        QWidget::setTabOrder(checkDropbox, checkGit);
        QWidget::setTabOrder(checkGit, actionsCombo);
        QWidget::setTabOrder(actionsCombo, HttpHost);
        QWidget::setTabOrder(HttpHost, HttpPort);
        QWidget::setTabOrder(HttpPort, useAuth);
        QWidget::setTabOrder(useAuth, username);
        QWidget::setTabOrder(username, password);
        QWidget::setTabOrder(password, useSame);
        QWidget::setTabOrder(useSame, HttpsHost);
        QWidget::setTabOrder(HttpsHost, FtpHost);
        QWidget::setTabOrder(FtpHost, HttpsPort);
        QWidget::setTabOrder(HttpsPort, FtpPort);
        QWidget::setTabOrder(FtpPort, actionCmd);

        retranslateUi(ProxyMan);

        QMetaObject::connectSlotsByName(ProxyMan);
    } // setupUi

    void retranslateUi(QWidget *ProxyMan)
    {
        ProxyMan->setWindowTitle(QApplication::translate("ProxyMan", "ProxyMan", 0));
        targetGroup->setTitle(QApplication::translate("ProxyMan", "Select targets", 0));
        checkBash->setText(QApplication::translate("ProxyMan", "Bash", 0));
        checkEnv->setText(QApplication::translate("ProxyMan", "Environment variables", 0));
        checkGsettings->setText(QApplication::translate("ProxyMan", "Desktop settings", 0));
        checkApt->setText(QApplication::translate("ProxyMan", "Package manager", 0));
        checkNpm->setText(QApplication::translate("ProxyMan", "npm", 0));
        checkDropbox->setText(QApplication::translate("ProxyMan", "Dropbox", 0));
        checkGit->setText(QApplication::translate("ProxyMan", "git", 0));
        checkSelectAll->setText(QApplication::translate("ProxyMan", "Select All", 0));
        lblFtpPort->setText(QApplication::translate("ProxyMan", "FTP port", 0));
        lblFtpHost->setText(QApplication::translate("ProxyMan", "FTP host", 0));
        lblHttpPort->setText(QApplication::translate("ProxyMan", "HTTP port", 0));
        lblHttpsHost->setText(QApplication::translate("ProxyMan", "HTTPS host", 0));
        HttpHost->setPlaceholderText(QString());
        useAuth->setText(QApplication::translate("ProxyMan", "Use authentication", 0));
        useSame->setText(QApplication::translate("ProxyMan", "Use same for HTTPS and FTP ", 0));
        password->setPlaceholderText(QApplication::translate("ProxyMan", "Use %40 for @", 0));
        lblHttpsPort->setText(QApplication::translate("ProxyMan", "HTTPS port", 0));
        lblUsername->setText(QApplication::translate("ProxyMan", "Username", 0));
        lblPassword->setText(QApplication::translate("ProxyMan", "Password", 0));
        lblHttpHost->setText(QApplication::translate("ProxyMan", "HTTP host", 0));
        actionsCombo->clear();
        actionsCombo->insertItems(0, QStringList()
         << QApplication::translate("ProxyMan", "Set", 0)
         << QApplication::translate("ProxyMan", "Unset", 0)
        );
        actionCmd->setText(QApplication::translate("ProxyMan", "Apply", 0));
    } // retranslateUi

};

namespace Ui {
    class ProxyMan: public Ui_ProxyMan {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_PROXYMAN_H
