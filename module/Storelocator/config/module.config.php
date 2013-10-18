<?php

define("LANG_PARAMETER_NAME", 'lang');

$default_lang = 'en';

return array(
    'locale' => array(
        'default_lang' => $default_lang,
        'allowed_lang' => array(
            'en', 'it', 'es', 'fi'
        )
    ),
    'controllers' => array(
        'invokables' => array(
            'Storelocator\Controller\Storelocator' => 'Storelocator\Controller\StorelocatorController',
        ),
    ),
    'router' => array(
        'routes' => array(
            'storelocator_locale' => array(
                'type' => 'segment',
                'options' => array(//this will work with a 2 digit store code, a default store code and action with 3 or more chars
                    'route' => '[/:lang][/:action][/:id]',
                    'defaults' => array(
                        'lang' => $default_lang,
                    ),
                    'constraints' => array(
                        'lang' => '[a-z_]{2}',
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[a-zA-Z0-9_-]*',
                    ),
                    'defaults' => array(
                        'controller' => 'Storelocator\Controller\Storelocator',
                        'action' => 'index',
                    ),
                ),
            ),
        ),
    ),
    'view_manager' => array(
        'display_not_found_reason' => true,
        'display_exceptions' => true,
        'doctype' => 'HTML5',
        'not_found_template' => 'error/404',
        'exception_template' => 'error/index',
        'template_map' => array(
            'layout/layout' => __DIR__ . '/../view/layout/layout.phtml',
            'error/404' => __DIR__ . '/../view/error/404.phtml',
            'error/index' => __DIR__ . '/../view/error/index.phtml',
        ),
        'template_path_stack' => array(
            'storelocator_locale' => __DIR__ . '/../view',
        ),
    ),
);