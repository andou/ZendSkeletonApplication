<?php

namespace Storelocator\Controller;

use Storelocator\Controller\LocalizedController;
use Zend\View\Model\ViewModel;

class StorelocatorController extends LocalizedController {

  protected $_view;

  const TEMPL_PREFIX = 'Storelocator/Storelocator/';

  protected function _init() {
    $this->_view = $this->getTemplateView('content/page');

    $this->_view
            ->addChild($this->getTemplateView("content/overlay"), 'overlay')
            ->addChild($this->getTemplateView("content/header"), 'header');

    parent::_init();
  }

  protected function getTemplateView($template_name) {
    $view = new ViewModel();
    $view->setTemplate(self::TEMPL_PREFIX . '' . $template_name);
    return $view;
  }

  public function indexAction() {
    $this->_init();

    $page_content = new ViewModel(array(
        'lang' => $this->getLang(),
    ));
    $page_content->setTemplate(self::TEMPL_PREFIX . 'pages/index');
    $page_content
            ->addChild($this->getTemplateView("content/store-concept-preview"), 'store_concept_preview')
            ->addChild($this->getTemplateView("content/toolbar"), 'toolbar');



    $this->_view
            ->addChild($page_content, 'page_content');

    return $this->_view;
  }

  public function allstoresAction() {
    $this->_init();

    $page_content = new ViewModel(array(
        'lang' => $this->getLang(),
    ));
    $page_content->setTemplate(self::TEMPL_PREFIX . 'pages/all-stores');

    $this->_view->addChild($page_content, 'page_content');

    return $this->_view;
  }

  public function storeconceptAction() {    
    $this->_init();

    $page_content = new ViewModel(array(
        'lang' => $this->getLang(),
    ));
    $page_content->setTemplate(self::TEMPL_PREFIX . 'pages/store-concept');

    $this->_view->addChild($page_content, 'page_content');

    $this->layout()->body_class = 'internal';
    
    return $this->_view;
  }

  public function storesAction() {
    return $this->indexAction();
  }

  public function directionsAction() {
    return $this->indexAction();
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