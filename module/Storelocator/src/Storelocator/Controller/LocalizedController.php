<?php

namespace Storelocator\Controller;

use Zend\Mvc\Controller\AbstractActionController;

abstract class LocalizedController extends AbstractActionController {

  const DEFAULT_STORE = 'en';

  protected $_config;

  protected function getLang() {
    $lang_param = $this->params(LANG_PARAMETER_NAME) ? strtolower($this->params(LANG_PARAMETER_NAME)) : $this->getDefaultStoreCode();
    return $this->validateLang($lang_param) ? $lang_param : $this->getDefaultStoreCode();
  }

  protected function validateLang($lang_code) {
    $config = $this->getConfig();
    return in_array($lang_code, $config['locale']['allowed_' . LANG_PARAMETER_NAME]);
  }

  protected function getDefaultStoreCode() {
    $config = $this->getConfig();
    $default_store_code = $config['locale']['default_' . LANG_PARAMETER_NAME];

    return $default_store_code ? strtolower($default_store_code) : self::DEFAULT_STORE;
  }

  /**
   * Returns all the configurations
   * 
   * @return array configurations
   */
  protected function getConfig() {
    if (!isset($this->_config))
      $this->_config = $this->getServiceLocator()->get('config');
    return $this->_config;
  }

}