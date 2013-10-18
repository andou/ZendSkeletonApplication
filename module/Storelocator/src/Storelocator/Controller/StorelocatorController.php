<?php

namespace Storelocator\Controller;

use Storelocator\Controller\LocalizedController;
use Zend\View\Model\ViewModel;

class StorelocatorController extends LocalizedController {

  protected $_view;

  const TEMPL_PREFIX = 'Storelocator/Storelocator/';

  protected function _init() {
    $this->_view = new ViewModel();
    $this->_view->setTemplate(self::TEMPL_PREFIX . 'content/page');


    $headerView = new ViewModel();
    $headerView->setTemplate(self::TEMPL_PREFIX . 'content/header');


    $overlayView = new ViewModel();
    $overlayView->setTemplate(self::TEMPL_PREFIX . 'content/overlay');

    $this->_view->addChild($overlayView, 'overlay')
            ->addChild($headerView, 'header');

    parent::_init();
  }

  public function indexAction() {
    $this->_init();

    $page_content = new ViewModel(array(
        'lang' => $this->getLang(),
    ));
    $page_content->setTemplate(self::TEMPL_PREFIX . 'pages/index');

    $this->_view->addChild($page_content, 'page_content');

    return $this->_view;
  }

  public function storesAction() {
    $this->_init();

    $page_content = new ViewModel(array(
        'lang' => $this->getLang(),
    ));
    $page_content->setTemplate(self::TEMPL_PREFIX . 'pages/stores');

    $this->_view->addChild($page_content, 'page_content');

    return $this->_view;
  }

//  public function countryAction() {
//    $this->_init();
//    $request = $this->getRequest();
//
//    if ($request->isGet()) {
//      $_country_id = $this->params('id');
//
//      return new ViewModel(array(
//          'lang' => $this->getLang(),
//          'country_id' => $_country_id ? $_country_id : 'none'
//      ));
//    }
//  }
}