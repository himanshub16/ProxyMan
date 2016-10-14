/****************************************************************************
** Meta object code from reading C++ file 'proxyman.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.5.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../ProxyMan/proxyman.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'proxyman.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.5.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_ProxyMan_t {
    QByteArrayData data[9];
    char stringdata0[145];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ProxyMan_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ProxyMan_t qt_meta_stringdata_ProxyMan = {
    {
QT_MOC_LITERAL(0, 0, 8), // "ProxyMan"
QT_MOC_LITERAL(1, 9, 25), // "on_checkSelectAll_clicked"
QT_MOC_LITERAL(2, 35, 0), // ""
QT_MOC_LITERAL(3, 36, 7), // "checked"
QT_MOC_LITERAL(4, 44, 35), // "on_actionsCombo_currentIndexC..."
QT_MOC_LITERAL(5, 80, 5), // "index"
QT_MOC_LITERAL(6, 86, 20), // "on_actionCmd_clicked"
QT_MOC_LITERAL(7, 107, 18), // "on_useAuth_clicked"
QT_MOC_LITERAL(8, 126, 18) // "on_useSame_clicked"

    },
    "ProxyMan\0on_checkSelectAll_clicked\0\0"
    "checked\0on_actionsCombo_currentIndexChanged\0"
    "index\0on_actionCmd_clicked\0"
    "on_useAuth_clicked\0on_useSame_clicked"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ProxyMan[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    1,   39,    2, 0x08 /* Private */,
       4,    1,   42,    2, 0x08 /* Private */,
       6,    0,   45,    2, 0x08 /* Private */,
       7,    1,   46,    2, 0x08 /* Private */,
       8,    1,   49,    2, 0x08 /* Private */,

 // slots: parameters
    QMetaType::Void, QMetaType::Bool,    3,
    QMetaType::Void, QMetaType::Int,    5,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,    3,
    QMetaType::Void, QMetaType::Bool,    3,

       0        // eod
};

void ProxyMan::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ProxyMan *_t = static_cast<ProxyMan *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->on_checkSelectAll_clicked((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 1: _t->on_actionsCombo_currentIndexChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 2: _t->on_actionCmd_clicked(); break;
        case 3: _t->on_useAuth_clicked((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 4: _t->on_useSame_clicked((*reinterpret_cast< bool(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObject ProxyMan::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_ProxyMan.data,
      qt_meta_data_ProxyMan,  qt_static_metacall, Q_NULLPTR, Q_NULLPTR}
};


const QMetaObject *ProxyMan::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ProxyMan::qt_metacast(const char *_clname)
{
    if (!_clname) return Q_NULLPTR;
    if (!strcmp(_clname, qt_meta_stringdata_ProxyMan.stringdata0))
        return static_cast<void*>(const_cast< ProxyMan*>(this));
    return QWidget::qt_metacast(_clname);
}

int ProxyMan::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 5;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
