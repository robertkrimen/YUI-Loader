package JS::YUI::Loader::Catalog;

use strict;
use warnings;

use JSON;
use Scalar::Util qw/blessed/;
use JS::YUI::Loader::Item;
use Carp::Clan;

BEGIN { 
    my $json = JSON->new;
    my $catalog = $json->decode(map { local $_ = $_; s/'/"/g; $_ } (<<_END_));
{
        'animation': {
            'type': 'js',
            'path': 'animation/animation-min.js',
            'requires': ['dom', 'event']
        },

        'autocomplete': {
            'type': 'js',
            'path': 'autocomplete/autocomplete-min.js',
            'requires': ['dom', 'event'],
            'optional': ['connection', 'animation'],
            'skinnable': true
        },

        'base': {
            'type': 'css',
            'path': 'base/base-min.css',
            'after': ['reset', 'fonts', 'grids']
        },

        'button': {
            'type': 'js',
            'path': 'button/button-min.js',
            'requires': ['element'],
            'optional': ['menu'],
            'skinnable': true
        },

        'calendar': {
            'type': 'js',
            'path': 'calendar/calendar-min.js',
            'requires': ['event', 'dom'],
            'skinnable': true
        },

        'charts': {
            'type': 'js',
            'path': 'charts/charts-experimental-min.js',
            'requires': ['element', 'json', 'datasource']
        },

        'colorpicker': {
            'type': 'js',
            'path': 'colorpicker/colorpicker-min.js',
            'requires': ['slider', 'element'],
            'optional': ['animation'],
            'skinnable': true
        },

        'connection': {
            'type': 'js',
            'path': 'connection/connection-min.js',
            'requires': ['event']
        },

        'container': {
            'type': 'js',
            'path': 'container/container-min.js',
            'requires': ['dom', 'event'],
            'optional': ['dragdrop', 'animation', 'connection'],
            'supersedes': ['containercore'],
            'skinnable': true
        },

        'containercore': {
            'type': 'js',
            'path': 'container/container_core-min.js',
            'requires': ['dom', 'event'],
            'pkg': 'container'
        },

        'cookie': {
            'type': 'js',
            'path': 'cookie/cookie-beta-min.js',
            'requires': ['yahoo']
        },

        'datasource': {
            'type': 'js',
            'path': 'datasource/datasource-beta-min.js',
            'requires': ['event'],
            'optional': ['connection']
        },

        'datatable': {
            'type': 'js',
            'path': 'datatable/datatable-beta-min.js',
            'requires': ['element', 'datasource'],
            'optional': ['calendar', 'dragdrop'],
            'skinnable': true
        },

        'dom': {
            'type': 'js',
            'path': 'dom/dom-min.js',
            'requires': ['yahoo']
        },

        'dragdrop': {
            'type': 'js',
            'path': 'dragdrop/dragdrop-min.js',
            'requires': ['dom', 'event']
        },

        'editor': {
            'type': 'js',
            'path': 'editor/editor-beta-min.js',
            'requires': ['menu', 'element', 'button'],
            'optional': ['animation', 'dragdrop'],
            'skinnable': true
        },

        'element': {
            'type': 'js',
            'path': 'element/element-beta-min.js',
            'requires': ['dom', 'event']
        },

        'event': {
            'type': 'js',
            'path': 'event/event-min.js',
            'requires': ['yahoo']
        },

        'fonts': {
            'type': 'css',
            'path': 'fonts/fonts-min.css'
        },

        'get': {
            'type': 'js',
            'path': 'get/get-min.js',
            'requires': ['yahoo']
        },

        'grids': {
            'type': 'css',
            'path': 'grids/grids-min.css',
            'requires': ['fonts'],
            'optional': ['reset']
        },

        'history': {
            'type': 'js',
            'path': 'history/history-min.js',
            'requires': ['event']
        },

         'imagecropper': {
             'type': 'js',
             'path': 'imagecropper/imagecropper-beta-min.js',
             'requires': ['dom', 'event', 'dragdrop', 'element', 'resize'],
             'skinnable': true
         },

         'imageloader': {
            'type': 'js',
            'path': 'imageloader/imageloader-min.js',
            'requires': ['event', 'dom']
         },

         'json': {
            'type': 'js',
            'path': 'json/json-min.js',
            'requires': ['yahoo']
         },

         'layout': {
             'type': 'js',
             'path': 'layout/layout-beta-min.js',
             'requires': ['dom', 'event', 'element'],
             'optional': ['animation', 'dragdrop', 'resize', 'selector'],
             'skinnable': true
         }, 

        'logger': {
            'type': 'js',
            'path': 'logger/logger-min.js',
            'requires': ['event', 'dom'],
            'optional': ['dragdrop'],
            'skinnable': true
        },

        'menu': {
            'type': 'js',
            'path': 'menu/menu-min.js',
            'requires': ['containercore'],
            'skinnable': true
        },

        'profiler': {
            'type': 'js',
            'path': 'profiler/profiler-beta-min.js',
            'requires': ['yahoo']
        },


        'profilerviewer': {
            'type': 'js',
            'path': 'profilerviewer/profilerviewer-beta-min.js',
            'requires': ['profiler', 'yuiloader', 'element'],
            'skinnable': true
        },

        'reset': {
            'type': 'css',
            'path': 'reset/reset-min.css'
        },

        'reset-fonts-grids': {
            'type': 'css',
            'path': 'reset-fonts-grids/reset-fonts-grids.css',
            'supersedes': ['reset', 'fonts', 'grids', 'reset-fonts'],
            'rollup': 4
        },

        'reset-fonts': {
            'type': 'css',
            'path': 'reset-fonts/reset-fonts.css',
            'supersedes': ['reset', 'fonts'],
            'rollup': 2
        },

         'resize': {
             'type': 'js',
             'path': 'resize/resize-beta-min.js',
             'requires': ['dom', 'event', 'dragdrop', 'element'],
             'optional': ['animation'],
             'skinnable': true
         },

        'selector': {
            'type': 'js',
            'path': 'selector/selector-beta-min.js',
            'requires': ['yahoo', 'dom']
        },

        'simpleeditor': {
            'type': 'js',
            'path': 'editor/simpleeditor-beta-min.js',
            'requires': ['element'],
            'optional': ['containercore', 'menu', 'button', 'animation', 'dragdrop'],
            'skinnable': true,
            'pkg': 'editor'
        },

        'slider': {
            'type': 'js',
            'path': 'slider/slider-min.js',
            'requires': ['dragdrop'],
            'optional': ['animation']
        },

        'tabview': {
            'type': 'js',
            'path': 'tabview/tabview-min.js',
            'requires': ['element'],
            'optional': ['connection'],
            'skinnable': true
        },

        'treeview': {
            'type': 'js',
            'path': 'treeview/treeview-min.js',
            'requires': ['event'],
            'skinnable': true
        },

        'uploader': {
            'type': 'js',
            'path': 'uploader/uploader-experimental.js',
            'requires': ['yahoo']
        },

        'utilities': {
            'type': 'js',
            'path': 'utilities/utilities.js',
            'supersedes': ['yahoo', 'event', 'dragdrop', 'animation', 'dom', 'connection', 'element', 'yahoo-dom-event', 'get', 'yuiloader', 'yuiloader-dom-event'],
            'rollup': 8
        },

        'yahoo': {
            'type': 'js',
            'path': 'yahoo/yahoo-min.js'
        },

        'yahoo-dom-event': {
            'type': 'js',
            'path': 'yahoo-dom-event/yahoo-dom-event.js',
            'supersedes': ['yahoo', 'event', 'dom'],
            'rollup': 3
        },

        'yuiloader': {
            'type': 'js',
            'path': 'yuiloader/yuiloader-beta-min.js',
            'supersedes': ['yahoo', 'get']
        },

        'yuiloader-dom-event': {
            'type': 'js',
            'path': 'yuiloader-dom-event/yuiloader-dom-event.js',
            'supersedes': ['yahoo', 'dom', 'event', 'get', 'yuiloader', 'yahoo-dom-event'],
            'rollup': 5
        },

        'yuitest': {
            'type': 'js',
            'path': 'yuitest/yuitest-min.js',
            'requires': ['logger'],
            'skinnable': true
        }
}
_END_

    my %catalog;
    my %dependency_graph;
    for my $item (keys %$catalog) {
        $dependency_graph{$item} = [ @{ $catalog->{$item}->{requires} || [] } ];
        $catalog{$item} = JS::YUI::Loader::Item->parse($item => $catalog->{$item});
    }

    sub catalog {
        return \%catalog;
    }

    sub dependency_graph {
        return \%dependency_graph;
    }
}

sub names {
    my $class = shift;
    return keys %{ $class->catalog };
}

sub items {
    my $class = shift;
    return values %{ $class->catalog };
}

sub item {
    my $class = shift;
    my $name = shift;

    croak "Can't look up an item without a name" unless $name;
    return $name if blessed $name && $name->isa("JS::YUI::Loader::Item");
    croak "Couldn't find item for name \"$name\"" unless my $item = $class->catalog->{$name};
    return $item;
 
}

1;
