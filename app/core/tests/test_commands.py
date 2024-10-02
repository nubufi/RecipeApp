from unittest.mock import patch
from psycopg2 import OperationalError as Psycopg2Error
from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import SimpleTestCase


@patch("core.management.commands.wait_db.Command.check")
class CommandTests(SimpleTestCase):
    def test_wait_db_ready(self, mocked_check):
        """Test waiting for db when db is available"""
        mocked_check.return_value = True
        call_command("wait_db")

        mocked_check.assert_called_once_with(databases=["default"])

    @patch("time.sleep")
    def test_wait_db_delay(self, patched_sleep, mocked_checked):
        """Test waiting for db when getting OperationalError"""
        mocked_checked.side_effect = (
            [Psycopg2Error] * 2 + [OperationalError] * 3 + [True]
        )
        call_command("wait_db")

        self.assertEqual(mocked_checked.call_count, 6)

        mocked_checked.assert_called_with(databases=["default"])
