#include "proxyman.h"
#include "ui_proxyman.h"
#include <QObjectList>
#include <QList>
#include <QMessageBox>
#include <QTextStream>
#include <cstdlib>
#include <unistd.h>

ProxyMan::ProxyMan(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::ProxyMan)
{
    ui->setupUi(this);
    ui->username->setEnabled(false);
    ui->password->setEnabled(false);
}

ProxyMan::~ProxyMan()
{
    delete ui;
}

void ProxyMan::on_checkSelectAll_clicked(bool checked)
{
    for (int i = 0; i < ui->targetElems->count(); i++) {
        QCheckBox *cb = (QCheckBox*) ui->targetElems->itemAt(i)->widget();
        cb->setChecked(checked);
        cb->setEnabled(!checked); // that's the appropriate boolean value
    }
}

void ProxyMan::on_actionsCombo_currentIndexChanged(int index)
{
    if (index == 1) {
        for (int i = 0; i < ui->configGrid->count(); i++) {
            QLineEdit *le = (QLineEdit*) ui->configGrid->itemAt(i)->widget();
            le->setEnabled(true);
        }
    } else {
        for (int i = 0; i < ui->configGrid->count(); i++) {
            QLineEdit *le = (QLineEdit*) ui->configGrid->itemAt(i)->widget();
            le->setEnabled(true);
        }
    }
}

void ProxyMan::on_actionCmd_clicked()
{
    QString argument;
    QString usesame, useauth;
    QMessageBox msg;
        msg.setStandardButtons(QMessageBox::Ok);
        msg.setDefaultButton(QMessageBox::Ok);
        msg.setStyleSheet("background-color: white;");

    if (ui->actionsCombo->currentIndex() == 1) {
        argument = "unset "; // I need this space badly to avoid a bug. Will find a fix.
    } else {

        if (ui->HttpHost->text().isEmpty()) {
            msg.setText("<b>Empty values!</b>");
            msg.setInformativeText("Use unset to remove proxy instead.");
            msg.sizeHint();
            msg.exec();
            return;
        }

        usesame = (ui->useSame->isChecked()) ? "y" : "n";
        useauth = (ui->useAuth->isChecked()) ? "y" : "n";

        argument = "\"%1\" \"%2\" \"%3\" \"%4\" \"%5\" \"%6\" \"%7\" \"%8\" \"%9\" \"%10\"";
        argument = argument
                    .arg(ui->HttpHost->text())
                    .arg(ui->HttpPort->value())
                    .arg(usesame)
                    .arg(useauth)
                    .arg(ui->username->text())
                    .arg(ui->password->text())
                    .arg(ui->HttpsHost->text())
                    .arg(ui->HttpsPort->value())
                    .arg(ui->FtpHost->text())
                    .arg(ui->FtpPort->value()) ;
    }

    char pwd[1000];
    QString sudoprefix = "pkexec bash ";
    getcwd(pwd,800);
    sudoprefix += QString(pwd) + "/";

    QString sudosysarg = sudoprefix+"%1 %2";
    sudosysarg.append("bash %1 %2");
    QString sysarg = "bash %1 %2";

    char *mystring = pwd; // don't waste memory. reuse it.
    QTextStream out(stdout);

    if (ui->checkBash->isChecked()) {
        out << sysarg.arg("bash.sh").arg(argument) << endl;
        mystring = (sysarg.arg("bash.sh").arg(argument)).toLatin1().data();
        system(mystring);
    }

    if (ui->checkApt->isChecked()) {
        out << sudosysarg.arg("apt.sh").arg(argument) << endl;
        mystring = (sudosysarg.arg("apt.sh").arg(argument)).toLatin1().data();
        system(mystring);
    }

    if (ui->checkEnv->isChecked()) {
        out << sudosysarg.arg("environment.sh").arg(argument) << endl;
        mystring = (sudosysarg.arg("environment.sh").arg(argument)).toLatin1().data();
        system(mystring);
    }

    if (ui->checkGsettings->isChecked()) {
        out << sysarg.arg("gsettings.sh").arg(argument) << endl;
        mystring = (sysarg.arg("gsettings.sh").arg(argument)).toLatin1().data();
        system(mystring);
    }

    if (ui->checkNpm->isChecked()) {
        out << sysarg.arg("npm.sh").arg(argument) << endl;
        mystring = (sysarg.arg("npm.sh").arg(argument)).toLatin1().data();
        system(mystring);

    }

    if (ui->checkDropbox->isChecked()) {
        out << sysarg.arg("dropbox.sh").arg(argument) << endl;
        mystring = (sysarg.arg("dropbox.sh").arg(argument)).toLatin1().data();
        system(mystring);
    }

    if (ui->checkGit->isChecked()) {
        out << sysarg.arg("git_config.sh").arg(argument) << endl;
        mystring = (sysarg.arg("git_config.sh").arg(argument)).toLatin1().data();
        system(mystring);
    }

    msg.setText("<b>Done!</b>");
    msg.setInformativeText("Thanks for using :)");
    msg.exec();
    qApp->quit();


}

void ProxyMan::on_useAuth_clicked(bool checked)
{
    if (checked) {
        ui->username->setEnabled(true);
        ui->password->setEnabled(true);
    } else {
        ui->username->setText("");
        ui->password->setText("");
        ui->username->setEnabled(false);
        ui->password->setEnabled(false);
    }
}

void ProxyMan::on_useSame_clicked(bool checked)
{
    if (checked) {
        ui->HttpsHost->setEnabled(false);
        ui->HttpsPort->setEnabled(false);
        ui->FtpHost->setEnabled(false);
        ui->FtpPort->setEnabled(false);

        QString commonHost = ui->HttpHost->text();
        int commonPort = ui->HttpPort->value();

        ui->HttpsHost->setText(commonHost);
        ui->FtpHost->setText(commonHost);
        ui->HttpsPort->setValue(commonPort);
        ui->FtpPort->setValue(commonPort);

    } else {
        ui->HttpsHost->setEnabled(true);
        ui->HttpsPort->setEnabled(true);
        ui->FtpHost->setEnabled(true);
        ui->FtpPort->setEnabled(true);
    }

}
