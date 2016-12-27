#ifndef PROXYMAN_H
#define PROXYMAN_H

#include <QWidget>

namespace Ui {
class ProxyMan;
}

class ProxyMan : public QWidget
{
    Q_OBJECT

public:
    explicit ProxyMan(QWidget *parent = 0);
    ~ProxyMan();

private slots:
    void on_checkSelectAll_clicked(bool checked);

    void on_actionsCombo_currentIndexChanged(int index);

    void on_actionCmd_clicked();

    void on_useAuth_clicked(bool checked);

    void on_useSame_clicked(bool checked);

private:
    Ui::ProxyMan *ui;
};

#endif // PROXYMAN_H
