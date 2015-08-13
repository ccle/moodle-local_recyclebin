<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * This page shows the contents of a recyclebin for a given course.
 *
 * @package    local_recyclebin
 * @copyright  2015 University of Kent
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require_once(dirname(__FILE__) . '/../../config.php');
require_once($CFG->libdir . '/tablelib.php');

$courseid = required_param('course', PARAM_INT);
$action = optional_param('action', null, PARAM_ALPHA);
$coursecontext = \context_course::instance($courseid, MUST_EXIST);

require_login($courseid);
require_capability('local/recyclebin:view', $coursecontext);

$PAGE->set_url('/local/recyclebin/index.php', array(
    'course' => $courseid
));
$PAGE->set_title(get_string('pluginname', 'local_recyclebin'));

$recyclebin = new \local_recyclebin\RecycleBin($courseid);

// If we are doing anything, we need a sesskey!
if (!empty($action)) {
    raise_memory_limit(MEMORY_EXTRA);
    require_sesskey();

    $item = null;
    if ($action == 'restore' || $action == 'delete') {
        $itemid = required_param('itemid', PARAM_INT);
        $item = $DB->get_record('local_recyclebin', array(
            'id' => $itemid
        ), '*', MUST_EXIST);
    }

    switch ($action) {
        // Restore it.
        case 'restore':
            require_capability('local/recyclebin:restore', $coursecontext);
            $recyclebin->restore_item($item);
            redirect($PAGE->url, get_string('alertrestored', 'local_recyclebin', $item), 2);
        break;

        // Delete it.
        case 'delete':
            require_capability('local/recyclebin:delete', $coursecontext);
            $recyclebin->delete_item($item);
            redirect($PAGE->url, get_string('alertdeleted', 'local_recyclebin', $item), 2);
        break;

        // Empty it.
        case 'empty':
            require_capability('local/recyclebin:empty', $coursecontext);
            $recyclebin->empty_recycle_bin();
            redirect($PAGE->url, get_string('alertemptied', 'local_recyclebin'), 2);
        break;
    }
}

// Output header.
echo $OUTPUT->header();
echo $OUTPUT->heading($PAGE->title);
// START UCLA MOD: CCLE-5298 - Recycle Bin Refinements
// Add a description.
echo $OUTPUT->box(get_string('description', 'local_recyclebin'));
// END UCLA MOD: CCLE-5298

// Grab our items, check there is actually something to display.
$items = $recyclebin->get_items();

// Nothing to show? Bail out early.
if (empty($items)) {
    echo $OUTPUT->box(get_string('emptybin', 'local_recyclebin'));
    // START UCLA MOD: CCLE-5298 - Recycle Bin Refinements
    // Add a "Go Back" button.
    $goback = new \moodle_url('/course/view.php', array('id' => $courseid));
    echo \html_writer::link($goback, get_string('goback', 'local_recyclebin'),
            array('class' => 'recycle-bin-button'));
    // END UCLA MOD: CCLE-5298
    echo $OUTPUT->footer();
    die;
}

// Check permissions.
$canrestore = has_capability('local/recyclebin:restore', $coursecontext);
$candelete = has_capability('local/recyclebin:delete', $coursecontext);

// Strings.
$restorestr = get_string('restore');
$deletestr = get_string('delete');

// Define columns and headers.
$columns = array('activity', 'date');
$headers = array(
    get_string('activity'),
    get_string('deleted', 'local_recyclebin')
);

// START UCLA MOD: CCLE-5298 - Recycle Bin Refinements
// Switch the 'Restore' and 'Delete' columns.
// if ($canrestore) {
//     $columns[] = 'restore';
//     $headers[] = $restorestr;
// }
//
// if ($candelete) {
//     $columns[] = 'delete';
//     $headers[] = $deletestr;
// }

if ($candelete) {
    $columns[] = 'delete';
    $headers[] = $deletestr;
}
if ($canrestore) {
    $columns[] = 'restore';
    $headers[] = $restorestr;
}
// END UCLA MOD: CCLE-5298

// Define a table.
$table = new flexible_table('recyclebin');
$table->define_columns($columns);
$table->define_headers($headers);
$table->define_baseurl($PAGE->url);
$table->set_attribute('id', 'recycle-bin-table');
$table->setup();

// Cache a list of modules.
$modules = $DB->get_records('modules');

// Add all the items to the table.
foreach ($items as $item) {
    $row = array();

    // Build item name.
    $icon = '';
    if (isset($modules[$item->module])) {
        $mod = $modules[$item->module];
        $modname = get_string('modulename', $mod->name);
        $icon = '<img src="' . $OUTPUT->pix_url('icon', $mod->name) . '" class="icon" alt="' . $modname . '" /> ';
    }

    $row[] = "{$icon}{$item->name}";
    $row[] = userdate($item->deleted);

    // START UCLA MOD: CCLE-5298 - Recycle Bin Refinements
    // Switch the 'Restore' and 'Delete' columns.
    //
    // // Build restore link.
    // if ($canrestore) {
    //     $restore = '';
    //     if (isset($modules[$item->module])) {
    //         $restore = new \moodle_url('/local/recyclebin/index.php', array(
    //             'course' => $courseid,
    //             'itemid' => $item->id,
    //             'action' => 'restore',
    //             'sesskey' => sesskey()
    //         ));
    //         $restore = \html_writer::link($restore, '<i class="fa fa-history"></i>', array(
    //             'alt' => $restorestr
    //         ));
    //     }
    //
    //     $row[] = $restore;
    // }
    //
    // // Build delete link.
    // if ($candelete) {
    //     $delete = new \moodle_url('/local/recyclebin/index.php', array(
    //         'course' => $courseid,
    //         'itemid' => $item->id,
    //         'action' => 'delete',
    //         'sesskey' => sesskey()
    //     ));
    //     $delete = $OUTPUT->action_icon($delete, new pix_icon('t/delete', get_string('delete'), '', array('class' => 'iconsmall')));
    //
    //     $row[] = $delete;
    // }

    // Build delete link.
    if ($candelete) {
        $delete = new \moodle_url('/local/recyclebin/index.php', array(
            'course' => $courseid,
            'itemid' => $item->id,
            'action' => 'delete',
            'sesskey' => sesskey()
        ));
        $delete = $OUTPUT->action_icon($delete, new pix_icon('t/delete', get_string('delete'), '', array('class' => 'iconsmall')));

        $row[] = $delete;
    }

    // Build restore link.
    if ($canrestore) {
        $restore = '';
        if (isset($modules[$item->module])) {
            $restore = new \moodle_url('/local/recyclebin/index.php', array(
                'course' => $courseid,
                'itemid' => $item->id,
                'action' => 'restore',
                'sesskey' => sesskey()
            ));
            $restore = $OUTPUT->action_icon($restore, new pix_icon('t/restore', get_string('restore'), '', array('class' => 'iconsmall')));
        }

        $row[] = $restore;
    }
    // END UCLA MOD: CCLE-5298

    $table->add_data($row);
}

// Display the table now.
// START UCLA MOD: CCLE-5298 - Recycle Bin Refinements
// $table->print_html();
// Only print if there are items.
if (!empty($items)) {
    $table->print_html();
}

// START UCLA MOD: CCLE-5298 - Recycle Bin Refinements
// Add a "Go Back" button.
$goback = new \moodle_url('/course/view.php', array('id' => $courseid));
echo \html_writer::link($goback, get_string('goback', 'local_recyclebin'),
        array('class' => 'recycle-bin-button'));
// END UCLA MOD: CCLE-5298

// Empty recyclebin link.
if (has_capability('local/recyclebin:empty', $coursecontext)) {
    $empty = new \moodle_url('/local/recyclebin/index.php', array(
        'course' => $courseid,
        'action' => 'empty',
        'sesskey' => sesskey()
    ));

    // START UCLA MOD: CCLE-5298 - Recycle Bin Refinements
    $PAGE->requires->string_for_js('emptyconfirm', 'local_recyclebin');
    $PAGE->requires->js_init_call('M.local_recyclebin.init');
    // END UCLA MOD CCLE-5298

    // START UCLA MOD: CCLE-5280 - Improve Recycle Bin Appearance.
    //echo \html_writer::link($empty, get_string('empty', 'local_recyclebin'));
    // START UCLA MOD: CCLE-5298 - Recycle Bin Refinements.
    // echo \html_writer::link($empty, get_string('empty', 'local_recyclebin'),
    //     array('id' => 'recycle-bin-empty-link'));
    if (!empty($items)) {
        echo \html_writer::link($empty, get_string('empty', 'local_recyclebin'),
            array('class' => 'recycle-bin-button recycle-bin-delete-all'));
    }
    // END UCLA MOD: CCLE-5298
    // END UCLA MOD: CCLE-5280
}

// Output footer.
echo $OUTPUT->footer();
