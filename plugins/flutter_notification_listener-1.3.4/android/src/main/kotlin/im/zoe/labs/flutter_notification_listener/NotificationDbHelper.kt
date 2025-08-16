package im.zoe.labs.flutter_notification_listener

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues

class NotificationDbHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_NAME = "notifications.db"
        private const val DATABASE_VERSION = 1

        const val TABLE_NAME = "notifications"
        const val COLUMN_ID = "id"
        const val COLUMN_PACKAGE = "package_name"
        const val COLUMN_TITLE = "title"
        const val COLUMN_TEXT = "text"
        const val COLUMN_TIMESTAMP = "timestamp"
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createTable = """
            CREATE TABLE $TABLE_NAME (
                $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COLUMN_PACKAGE TEXT,
                $COLUMN_TITLE TEXT,
                $COLUMN_TEXT TEXT,
                $COLUMN_TIMESTAMP INTEGER
            );
        """.trimIndent()
        db.execSQL(createTable)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

    fun insertNotification(
        packageName: String?,
        title: String?,
        text: String?,
        timestamp: Long
    ) {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COLUMN_PACKAGE, packageName)
            put(COLUMN_TITLE, title)
            put(COLUMN_TEXT, text)
            put(COLUMN_TIMESTAMP, timestamp)
        }
        db.insert(TABLE_NAME, null, values)
    }
}
