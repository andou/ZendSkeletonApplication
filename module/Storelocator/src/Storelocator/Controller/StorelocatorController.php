<?php

namespace Storelocator\Controller;

use Storelocator\Controller\LocalizedController;
use Zend\View\Model\ViewModel;

class StorelocatorController extends LocalizedController {

  protected $_view;

  protected function _init() {
    $this->_view = new ViewModel();
    $this->_view->setTemplate('Storelocator/Storelocator/content/page');


    $headerView = new ViewModel();
    $headerView->setTemplate('Storelocator/Storelocator/content/header');

    $pageContentView = new ViewModel();
    $pageContentView->setTemplate('Storelocator/Storelocator/pippo');


    $overlayView = new ViewModel();
    $overlayView->setTemplate('Storelocator/Storelocator/content/overlay');

    $includsJsView = new ViewModel();
    $includsJsView->setTemplate('Storelocator/Storelocator/content/include_js');

    $this->_view->addChild($overlayView, 'overlay')->addChild($headerView, 'header')->addChild($includsJsView, 'include_js');

    parent::_init();
  }

  public function indexAction() {
    $this->_init();

    $page_content = new ViewModel(array(
        'lang' => $this->getLang(),
    ));
    $page_content->setTemplate('Storelocator/Storelocator/pages/index');

    $this->_view->addChild($page_content, 'page_content');

    return $this->_view;
  }

  public function storesAction() {
    $this->_init();

    $page_content = new ViewModel(array(
        'lang' => $this->getLang(),
    ));
    $page_content->setTemplate('Storelocator/Storelocator/pages/stores');

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